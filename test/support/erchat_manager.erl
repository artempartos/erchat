-module(erchat_manager).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-include("include/cowboy_req.hrl").

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(UUID) ->
  gen_server:start_link(?MODULE, [UUID], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([UUID]) ->
  case erchat_handler:init(nil, #http_req{bindings=[{uuid, erlang:list_to_binary(UUID)}]}, [], []) of
    {ok, Req2, {ready, []}} ->
      {ok, [ready]};
    {shutdown, Req2, []} ->
      {ok, [noready]}
  end.

handle_call({get, info}, _From, State = [UserStatus]) ->
  {reply, {ok, UserStatus}, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
