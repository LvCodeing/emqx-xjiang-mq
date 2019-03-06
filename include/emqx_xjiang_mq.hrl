%%%-------------------------------------------------------------------
%%% @author tong
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Nov 2018 4:25 PM
%%%-------------------------------------------------------------------
-author("tong").

-define(APP, emq_xjiang_mq).

-define(KAFKA_CLIENT, kafka_client).

-define(KAFKA_DEVICE_ACTIVE, <<"device-active">>).
-define(KAFKA_DEVICE_DATA_UP, <<"device-data-up">>).
-define(KAFKA_DEVICE_ERR_UP, <<"device-err-up">>).
-define(KAFKA_DEVICE_CLOUD_DOWN, <<"device-cloud-down">>).
-define(KAFKA_DEVICE_STATUS, <<"device-status">>).
-define(KAFKA_USER_STATUS, <<"user-status">>).
-define(KAFKA_USER_CTRL, <<"user-ctrl">>).
