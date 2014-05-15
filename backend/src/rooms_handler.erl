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
  erlang:display(1111),
  ok.

reply(Req) ->
  	cowboy_req:reply(200, [
                           {<<"Access-Control-Allow-Origin">>, <<"*">>},
                           {<<"content-type">>, <<"text/plain; charset=utf-8">>}
                          ], <<"hallo!!11">>, Req).
