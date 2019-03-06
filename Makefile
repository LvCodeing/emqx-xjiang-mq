PROJECT = emqx_xjiang_mq
PROJECT_DESCRIPTION = EMQ Plugin Template
PROJECT_VERSION = 2.3.6

DEPS = brod
dep_brod = git https://github.com/klarna/brod.git 3.7.2

BUILD_DEPS = emqttd cuttlefish
dep_emqx = git https://github.com/emqx/emqx.git master
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

#dep_amqp_client = git https://github.com/rabbitmq/rabbitmq-erlang-client  v3.7.8

ERLC_OPTS += +debug_info
ERLC_OPTS += +'{parse_transform, lager_transform}'

NO_AUTOPATCH = cuttlefish

COVER = true

include erlang.mk

app:: rebar.config

app.config::
	./deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emqx_xjiang_mq.conf -i priv/emqx_xjiang_mq.schema -d data
