FROM node:8-alpine

RUN apk add --no-cache curl unzip wget git bash \
                       fontconfig xorg-server \
                       libc6-compat libxrender && \
    echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache icu-libs@edge poppler@edge texlive@community \
                       libressl@edge qt5-qtbase@community qt5-qtwebkit@community wkhtmltopdf@testing

# texlive seems to be working...
# wkhtmltopdf package doesn't work at the moment...

# install fonts
RUN mkdir -p ~/.fonts \
  && cd ~/.fonts \
  && curl -SLO https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKsc-hinted.zip \
  && unzip *.zip \
  && rm *.zip \
  && cd - \
  && fc-cache -fv

# Install pandoc
ENV PANDOC_VERSION 2.1.1
RUN curl -SLO "https://github.com/jgm/pandoc/releases/download/$PANDOC_VERSION/pandoc-$PANDOC_VERSION-linux.tar.gz" \
  && tar xvzf pandoc-$PANDOC_VERSION-linux.tar.gz --strip-components 1 -C /usr/local \
  && rm pandoc-$PANDOC_VERSION-linux.tar.gz

RUN git clone https://github.com/benweet/stackedit /opt/stackedit

WORKDIR /opt/stackedit

ENV SERVE_V4 true
ENV NPM_CONFIG_LOGLEVEL warn

RUN npm install -g yarn gulp && \
    npm install --unsafe-perm && npm cache clean --force && \
    npm run build

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "."]
