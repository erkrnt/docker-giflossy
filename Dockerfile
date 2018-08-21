# giflossy stage
FROM alpine:3.8 as giflossy
RUN apk add --no-cache \
  autoconf \
  automake \
  curl \
  g++ \
  make \
  tar
RUN curl -o /tmp/1.91.tar.gz https://codeload.github.com/kornelski/giflossy/tar.gz/1.91
WORKDIR /tmp
RUN tar -vxzf 1.91.tar.gz
WORKDIR giflossy-1.91
RUN autoreconf -i \
  && ./configure \
  && make \
  && make install

# Final build
FROM node:10.7.0-alpine
RUN apk add --no-cache \
  curl \
  ffmpeg \
  imagemagick
COPY --from=giflossy /usr/local/bin/gifdiff /usr/local/bin/gifdiff
COPY --from=giflossy /usr/local/bin/gifsicle /usr/local/bin/gifsicle
CMD [ "node" ]