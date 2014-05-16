-module(chats_gen).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

init(_Transport, Req, []) ->
    lager:notice("toppage init"),
    {ok, Req, undefined}.

handle(Req, State) ->
    Html = get_html(),
    lager:notice("toppage handle"),
    {ok, Req2} = cowboy_req:reply(200,
                                  [{<<"content-type">>, <<"text/html">>}],
                                  Html, Req),
    lager:notice("toppage send"),
    {ok, Req2, State}.


terminate(_Reason, _Req, _State) ->
    ok.

get_html() ->
    {ok, Cwd} = file:get_cwd(),
    Filename =filename:join([Cwd, "priv", "html_ws_client.html"]),
    {ok, Binary} = file:read_file(Filename),
    Binary.
