-module(erchat).
-export([start/0, stop/0, create_room/0]).

start() ->
    {ok, _} = application:ensure_all_started(?MODULE).

stop() ->
  Apps = [erchat, gproc, ranch, cowboy],
  [application:stop(App) || App <- Apps],
  ok.

create_room() ->
  UUID = uuid:to_string(uuid:uuid1()),
  {ok, Pid} = supervisor:start_child(room_sup, [UUID]),
  rooms_server:new_room(UUID, Pid),
  {ok, UUID}.
