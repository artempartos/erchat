-module(erchat_handler).

-export([init/4]).
-export([stream/3]).
-export([info/3]).
-export([terminate/2]).


init(_Transport, Req, _Opts, _Active) ->
  {BitUUID, Req2} = cowboy_req:binding(uuid, Req),
  UUID = erlang:binary_to_list(BitUUID),
  %% get history
  case rooms_server:get_room_pid(UUID) of
    undefined ->
      {shutdown, Req2, []};
    Pid ->
      gproc:reg({p, l, UUID}),
      {ok, Req2, {Pid, empty}}
  end.

stream({nickname, Nickname}, Req, {RoomPid, empty}) ->
  gen_server:cast(RoomPid, {new_user, Nickname}),
  {ok, Req, {RoomPid, Nickname}};

stream({message, Message}, Req, State = {RoomPid, Nickname}) ->
  gen_server:cast(RoomPid, {new_message, Nickname, Message}),
  {ok, Req, State};

stream(_Data, Req, State) ->
  {ok, Req, State}.

info(_Info, Req, State) ->
  {ok, Req, State}.

terminate(_Req, _TRef) ->
  ok.
