FROM bitwalker/alpine-erlang:19.2.1b

MAINTAINER Fabien Henon <henon.fabien@softcreations.fr>

ENV HOME=/opt/app/ TERM=xterm

# Install Elixir and basic build dependencies
RUN \
    echo "@edge http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk --no-cache --update add \
      git make g++ \
      build-base gtest gtest-dev boost boost-dev protobuf protobuf-dev cmake icu icu-dev openssl \
      elixir@edge && \
    rm -rf /var/cache/apk/*

RUN \
  cd /tmp && \
  wget https://github.com/googlei18n/libphonenumber/archive/v8.4.0.tar.gz && \
  tar xf v8.4.0.tar.gz && \
  cd libphonenumber-8.4.0 && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_INSTALL_PREFIX=/usr ../cpp && \
  make -Wno-error=deprecated-declarations -j $(grep -c ^processor /proc/cpuinfo) && \
  cp *.a /usr/lib/ && \
  cp *.so* /usr/lib && \
  cp -R ../cpp/src/phonenumbers /usr/include/

# Install Hex+Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /opt/app

CMD ["/bin/sh"]
