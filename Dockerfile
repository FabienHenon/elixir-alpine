FROM bitwalker/alpine-erlang:20.0.1

MAINTAINER Fabien Henon <henon.fabien@softcreations.fr>

ENV HOME=/opt/app/ \
    TERM=xterm \
    REFRESHED_AT=2017-07-25 \
    ELIXIR_VERSION=v1.6.1

RUN \
    apk --no-cache --update upgrade && \
    apk add --no-cache --update --virtual .elixir-build \
      make && \
    apk add --no-cache --update \
      git && \
    git clone https://github.com/elixir-lang/elixir && \
    cd elixir && \
    git checkout $ELIXIR_VERSION && \
    make && make install && \
    mix local.hex --force && \
    mix local.rebar --force && \
    cd $HOME && \
    rm -rf /tmp/elixir-build && \
    apk del .elixir-build

WORKDIR /opt/app

CMD ["/bin/sh"]
