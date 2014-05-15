-module(rooms_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
  {ok, Req, undefined}.

handle(Req, State) ->
  {ok, Req2} = reply(Req),
  {ok, Req2, State}.


terminate(_Reason, _Req, _State) ->
  ok.

reply(Req) ->
  Rooms = rooms_server:get_rooms(),
  Response = create_response(Rooms),
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