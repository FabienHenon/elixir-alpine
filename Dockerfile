FROM bitwalker/alpine-erlang:20.0.1

MAINTAINER Fabien Henon <henon.fabien@softcreations.fr>

ENV HOME=/opt/app/ \
    TERM=xterm \
    REFRESHED_AT=2017-07-25 \
    ELIXIR_VERSION=v1.5.1

WORKDIR /tmp/elixir-build

# Install Elixir and basic build dependencies
RUN \
    apk --no-cache --update upgrade && \
    apk add --no-cache --update --virtual .elixir-build \
      make && \
    apk add --no-cache --update \
      git make g++ \
      build-base gtest gtest-dev boost boost-dev protobuf protobuf-dev cmake icu icu-dev openssl && \
    git clone https://github.com/elixir-lang/elixir && \
    cd elixir && \
    git checkout $ELIXIR_VERSION && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del .elixir-build


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


WORKDIR /opt/app

CMD ["/bin/sh"]
