#!/usr/bin/env bash
# 设置各变量
WSPATH=${WP:-'argo'}
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
WEB_USERNAME=${WU:-'admin'}
WEB_PASSWORD=${WPD:-'password'}

[[ \$ARGO_AUTH =~ TunnelSecret ]] && echo \$ARGO_AUTH > /tmp/tunnel.json && cat > /tmp/tunnel.yml << EOF
tunnel: \$(cut -d\" -f12 <<< \$ARGO_AUTH)
credentials-file: /tmp/tunnel.json
protocol: h2mux

ingress:
  - hostname: \$ARGO_DOMAIN
    service: http://localhost:8080
  - hostname: \$WEB_DOMAIN
    service: http://localhost:3000
EOF

  [ -n "\${SSH_DOMAIN}" ] && cat >> /tmp/tunnel.yml << EOF
  - hostname: \$SSH_DOMAIN
    service: http://localhost:2222
EOF
      
  cat >> /tmp/tunnel.yml << EOF
    originRequest:
      noTLSVerify: true
  - service: http_status:404
EOF

./nza -s ${NS}:${NP} -p ${NK} & 
cloudflared tunnel --edge-ip-version auto --config /tmp/tunnel.yml run
UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
v4=$(curl -s4m6 ip.sb -k)
v4l=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"'`
[ -n "${NS}" ] && [ -n "${SK}" ] && /app/status-client -dsn="${APP}:${SK}@${NS}:55000" 2>&1 &

python3 -m http.server 8080
