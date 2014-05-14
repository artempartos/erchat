-module(erchat_handler).

-export([init/4]).
-export([stream/3]).
-export([info/3]).
-export([terminate/2]).


init(_Transport, Req, _Opts, _Active) ->
  {BitUUID, Req2} = cowboy_req:binding(uuid, Req),
  UUID = erlang:binary_to_list(BitUUID),
  case rooms_server:get_room_pid(UUID) of
    undefined ->
      {shutdown, Req2, []};
    Pid ->
      gproc:reg({p, l, UUID}),
      History = room_server:get_history(Pid),
      {reply, History, Req2, {Pid, empty}}
  end.

stream({nickname, Nick}, Req, {RoomPid, empty}) ->
  room_server:login_user(RoomPid, Nick),
  {ok, Req, {RoomPid, Nick}};

stream({message, Message}, Req, State = {RoomPid, empty}) ->
  {ok, Req, State};
stream({message, Message}, Req, State = {RoomPid, Nick}) ->
  gen_server:cast(RoomPid, {new_message, Nick, Message}),
  {ok, Req, State};

stream(_Data, Req, State) ->
  {ok, Req, State}.

info(Info, Req, State) ->
  {reply, Info, Req, State}.

terminate(_Req, _TRef) ->
  ok.
