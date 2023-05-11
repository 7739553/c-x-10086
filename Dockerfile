From ubuntu

EXPOSE 8080

RUN apt update -y && apt install curl sudo wget unzip python3 iproute2 vim net-tools -y

RUN echo 'root:123456' | chpasswd

RUN useradd -m cmcc -u 10086  && echo 'cmcc:123456' | chpasswd  && usermod -aG sudo cmcc \ 
    && echo 'cmcc ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/cmcc-nopasswd

RUN mkdir -p /app && chmod 777 /app

USER 10086
WORKDIR /app

COPY entrypoint.sh ./
RUN sudo chmod a+x entrypoint.sh 

RUN wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    wget -O td https://github.com/7739553/c-x-p/raw/main/files/ttyd &&\
    sudo dpkg -i cloudflared.deb &&\
    sudo rm -f cloudflared.deb &&\
    mkdir /tmp/v2ray &&\
    curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip &&\
    unzip /tmp/v2ray/xray.zip -d /tmp/v2ray &&\
    sudo install -m 755 /tmp/v2ray/xray /bin/xy &&\
    sudo install -m 644 /tmp/v2ray/geoip.dat  /bin/geoip.dat &&\
    sudo install -m 644 /tmp/v2ray/geosite.dat  /bin/geosite.dat &&\
    sudo rm -rf /tmp/v2ray &&\
    wget https://pkg.cloudflareclient.com/uploads/cloudflare_warp_2023_1_133_1_amd64_ba4cb58d64.deb &&\
    sudo dpkg -i cloudflare_warp_2023_1_133_1_amd64_ba4cb58d64.deb &&\
    sudo apt --fix-broken install -y &&\
    warp-cli register &&\
    warp-cli set-mode proxy &&\
    warp-cli enable-always-on &&\
    warp-cli connect &&\
    sudo rm -rf cloudflare_warp_2023_1_133_1_amd64_ba4cb58d64.deb
    
RUN wget https://github.com/naiba/nezha/releases/download/v0.14.11/nezha-agent_linux_amd64.zip \
    && unzip nezha-agent_linux_amd64.zip  && sudo mv nezha-agent nza && sudo chmod a+x nza td && sudo rm -f nezha-agent_linux_amd64.zip
   

CMD [ "bash", "./entrypoint.sh"]
