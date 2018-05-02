FROM ubuntu:18.04

# apt install
RUN apt update && apt install -y \
    lua5.2 liblua5.2-dev libpcre3 libpcre3-dev nodejs npm git wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# newer node and npm
RUN npm cache clean && \
    npm install n -g && \
    n 9.8.0 && \
    ln -sf /usr/local/bin/node /usr/bin/node && \
    apt-get purge -y nodejs npm

# install lrexlib
WORKDIR /tmp
RUN wget https://keplerproject.github.io/luarocks/releases/luarocks-2.4.1.tar.gz && \
    tar -xvzf luarocks-2.4.1.tar.gz && \
    cd luarocks-2.4.1 && \
    ./configure --lua-version=5.2 --versioned-rocks-dir && \
    make build && \
    make install && \
    luarocks-5.2 install lrexlib-pcre && \
    cd ../ && \
    rm -rf luarocks-2.4.1 luarocks-2.4.1.tar.gz

# install castl
WORKDIR /castl
RUN git clone https://github.com/PaulBernier/castl && \
    cd castl && \
    npm install && \
    npm link && \
    npm install castl -g

ENTRYPOINT [ "castl" ]