-module(rooms_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    {ok, Req, undefined}.

handle(Req, State) ->
    {ok, Req, State}.


terminate(_Reason, _Req, _State) ->
    ok.
