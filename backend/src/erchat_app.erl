-module(erchat_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile([
    {'_', [
      {"/rooms", rooms_handler, []},
      {"/rooms/[:uuid]", bullet_handler, [{handler, erchat_handler}]}
    ]}
  ]),
  {ok, Port} = application:get_env(erchat, port),
  {ok, _} = cowboy:start_http(http, 100, [{port, Port}], [
    {env, [{dispatch, Dispatch}]}
  ]),
  erchat_sup:start_link().

stop(_State) ->
  ok.
