-module(erchat).
-export([start/0, stop/0]).

start() ->
    {ok, _} = application:ensure_all_started(?MODULE).

stop() ->
  Apps = [cowboy, sync, erchat],
  [application:stop(App) || App <- Apps],
  ok.