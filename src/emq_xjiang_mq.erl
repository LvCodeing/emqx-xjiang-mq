%%%-------------------------------------------------------------------
%%% @author tong
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Nov 2018 8:32 PM
%%%-------------------------------------------------------------------
-module(emq_xjiang_mq).
-author("tong").

-include("emqx_xjiang_mq.hrl").

%% API
-export([device_active/5]).
-export([device_data_up/4, device_cloud_down/4, device_err_up/4, device_status/4]).
-export([user_ctrl/6, user_status/6]).

-import(emq_xjiang_util, [to_binary/1]).

-spec rand_0_7() -> any().
rand_0_7() -> 0.%%random:uniform(8) - 1.

device(Topic, Key, ProductKey, DeviceId, Data) ->
    lager:debug("kafka device topic:~p, key: ~p, deviceId:~p, data:~p", [Topic, Key, DeviceId, Data]),
    try
        Obj = {struct, [{<<"timestamp">>, emq_xjiang_util:timestamp()},
            {<<"product_key">>, ProductKey},
            {<<"device_id">>, DeviceId},
            {<<"data">>, to_binary(Data)}]},
        RJSON = emq_xjiang_json:encode(Obj),
        lager:debug("kafka device rjson: ~p~n", [RJSON]),
        brod:produce_no_ack(?KAFKA_CLIENT, Topic, rand_0_7(), Key, to_binary(RJSON))
    catch
        E: M -> lager:error("device ==== error: ~p, message: ~p~n", [E, M]), ok
    end.


device_active(<<"1">>, Key, ProductKey, DeviceId, _Data) ->
    device(?KAFKA_DEVICE_ACTIVE, Key, ProductKey, DeviceId, <<"">>);
device_active(_, _, _, _, _) -> ok.

device_data_up(Key, ProductKey, DeviceId, Data) ->
    device(?KAFKA_DEVICE_DATA_UP, Key, ProductKey, DeviceId, Data).

device_err_up(Key, ProductKey, DeviceId, Data) ->
    device(?KAFKA_DEVICE_ERR_UP, Key, ProductKey, DeviceId, Data).

device_cloud_down(Key, ProductKey, DeviceId, Data) ->
    device(?KAFKA_DEVICE_CLOUD_DOWN, Key, ProductKey, DeviceId, Data).

device_status(Key, ProductKey, DeviceId, Status) when is_atom(Status) ->
    device(?KAFKA_DEVICE_STATUS, Key, ProductKey, DeviceId, atom_to_binary(Status, utf8)).

user_status(Status, ClientId, Platform, UserId, DeveloperKey, Ip) ->
    try
        Obj = {struct, [{<<"timestamp">>, emq_xjiang_util:timestamp()},
            {<<"user_id">>, UserId},
            {<<"developer_key">>, DeveloperKey},
            {<<"platform">>, Platform},
            {<<"ip">>, Ip},
            {<<"state">>, atom_to_binary(Status, utf8)}]},
        RJSON = emq_xjiang_json:encode(Obj),
        brod:produce_no_ack(?KAFKA_CLIENT, ?KAFKA_USER_STATUS, rand_0_7(), ClientId, to_binary(RJSON))
    catch
        E: M -> lager:error("user status ===== error: ~p, message: ~p~n", [E, M]), ok
    end.

-spec user_ctrl(binary(), binary(), binary(), binary(), binary(), binary()) -> any().
user_ctrl(Key, UserId, DeveloperKey, ProductKey, DeviceId, Data) ->
    try
        Obj = {struct, [{<<"timestamp">>, emq_xjiang_util:timestamp()},
            {<<"user_id">>, UserId},
            {<<"developer_key">>, DeveloperKey},
            {<<"device_id">>, DeviceId},
            {<<"product_key">>, ProductKey},
            {<<"data">>, Data}]},
        RJSON = emq_xjiang_json:encode(Obj),
        brod:produce_no_ack(?KAFKA_CLIENT, ?KAFKA_USER_CTRL, rand_0_7(), Key, to_binary(RJSON))
    catch
        E: M -> lager:error("user ctrl ==== error: ~p, message: ~p~n", [E, M]), ok
    end.
