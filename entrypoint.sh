#!/usr/bin/env bash
# 设置各变量
WSPATH=${WP:-'argo'}
UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
WEB_USERNAME=${WU:-'admin'}
WEB_PASSWORD=${WPD:-'password'}

./nezha-agent -s ${NS}:${NP} -p ${NK} & 

UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
v4=$(curl -s4m6 ip.sb -k)
v4l=`curl -sm6 --user-agent "${UA_Browser}" http://ip-api.com/json/$v4?lang=zh-CN -k | cut -f2 -d"," | cut -f4 -d '"'`
[ -n "${NS}" ] && [ -n "${SK}" ] && /app/status-client -dsn="${APP}:${SK}@${NS}:55000" 2>&1 &

python3 -m http.server 8080
