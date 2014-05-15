-module(rooms_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
  {ok, Req, undefined}.

handle(Req, State) ->
  {Method, Req2} = cowboy_req:method(Req),
  handle(Method, Req, State).

handle(<<"GET">>, Req, State) ->
  Rooms = rooms_server:get_rooms(),
  Response = create_response(Rooms),
  {ok, Req2} = reply(Req, Response),
  {ok, Req2, State};
handle(<<"POST">>, Req, State) ->
  {ok, UUID} = erchat:create_room(),
  Response = jsx:encode([{uuid, erlang:list_to_binary(UUID)}]),
  {ok, Req2} = reply(Req, Response),
  {ok, Req2, State}.

terminate(_Reason, _Req, _State) ->
  ok.

reply(Req, Response) ->
	cowboy_req:reply(200, [
                         {<<"Access-Control-Allow-Origin">>, <<"*">>},
                         {<<"content-type">>, <<"application/json; charset=utf-8">>}
                        ], Response, Req).

create_response(Rooms) ->
  Mas = lists:map(fun(Room) ->
    RoomPid = rooms_server:get_room_pid(Room),
    Count = room_server:get_users_count(RoomPid),
    [{uuid, erlang:list_to_binary(Room)},{count, Count}]
  end, Rooms),
  jsx:encode(Mas).
