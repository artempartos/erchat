-module(erchat_handler).

-export([init/4]).
-export([stream/3]).
-export([info/3]).
-export([terminate/2]).

-export([event/3]).

init(_Transport, Req, _Opts, _Active) ->
  {BitUUID, Req2} = cowboy_req:binding(uuid, Req),
  UUID = erlang:binary_to_list(BitUUID),
  case rooms_server:get_room_pid(UUID) of
    undefined ->
      erlang:display([undefined, room, UUID]),
      {shutdown, Req2, []};
    Pid ->
      gproc:reg({p, l, UUID}),
      {ok, Req2, {Pid, empty}}
      %%{reply, History, Req2, {Pid, empty}}
  end.

stream(Message, Req, State) ->
  [{<<"event">>, BinEvent}, {<<"data">>, Data}] = jsx:decode(Message),
  Event = erlang:binary_to_atom(BinEvent, utf8),
  case event({Event, Data}, Req, State) of
    {reply, {ReplyEvent, ReplyData}, NewReq, NewState} ->
      JsonReply = jsx:encode([{event, ReplyEvent}, {data, ReplyData}]),
      {reply, JsonReply, NewReq, NewState};
    Value -> Value
  end.

event({get, <<"history">>}, Req, {RoomPid, Nick}) ->
  History = room_server:get_history(RoomPid),
  {reply, History, Req, {RoomPid, Nick}};

event({get, <<"users">>}, Req, {RoomPid, Nick}) ->
  Users = room_server:get_users(RoomPid),
  {reply, Users, Req, {RoomPid, Nick}};
  
event({nickname, Nick}, Req, {RoomPid, empty}) ->
  room_server:login_user(RoomPid, Nick),
  {reply, {you_logged, Nick}, Req, {RoomPid, Nick}};

event({message, _Message}, Req, State = {_RoomPid, empty}) ->
  {ok, Req, State};
event({message, Message}, Req, State = {RoomPid, Nick}) ->
  gen_server:cast(RoomPid, {new_message, Nick, Message}),
  {ok, Req, State}.


info({Event, Data}, Req, State) ->
  JsonReply = jsx:encode([{event, Event}, {data, Data}]),
  {reply, JsonReply, Req, State};
info(_Info, Req, State) ->
  {ok, Req, State}.

terminate(_Req, {RoomPid, Nick}) ->
  room_server:kick_user(RoomPid, Nick),
  ok.
