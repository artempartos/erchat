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
      {ok, Req2, {ready, []}}
  end.
  

stream(Data, Req, State) ->
  {ok, Req, State}.

info(Info, Req, State) ->
  {ok, Req, State}.

terminate(_Req, TRef) ->
  ok.
