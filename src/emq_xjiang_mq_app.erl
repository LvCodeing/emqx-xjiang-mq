%%--------------------------------------------------------------------
%% Copyright (c) 2013-2018 EMQ Enterprise, Inc. (http://emqtt.io)
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emq_xjiang_mq_app).

-behaviour(application).

-include("emqx_xjiang_mq.hrl").

%% Application callbacks
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    {ok, Sup} = emq_xjiang_mq_sup:start_link(),
    AllEnv = application:get_all_env(),
    io:format("application all env:~p~n", [AllEnv]),
    {ok, BrokerValues} = application:get_env(?APP, broker),
    KafkaHost = proplists:get_value(host, BrokerValues),
    KafkaPort = proplists:get_value(port, BrokerValues),
    application:ensure_all_started(brod),
    KafkaBootstrapEndpoints = [{KafkaHost, KafkaPort}],
    Topic = <<"test">>,
    Partition = 0,
    ok = brod:start_client(KafkaBootstrapEndpoints, ?KAFKA_CLIENT),
%%    ok = brod:start_producer(?KAFKA_CLIENT, Topic, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_DEVICE_ACTIVE, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_DEVICE_STATUS, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_DEVICE_DATA_UP, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_DEVICE_ERR_UP, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_DEVICE_CLOUD_DOWN, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_USER_STATUS, _ProducerConfig = []),
    ok = brod:start_producer(?KAFKA_CLIENT, ?KAFKA_USER_CTRL, _ProducerConfig = []),

%%    {ok, FirstOffset} = brod:produce_sync_offset(?KAFKA_CLIENT, Topic, Partition, <<"key1">>, <<"value1">>),

    {ok, Sup}.

stop(_State) ->
    brod:stop(),
    ok.
