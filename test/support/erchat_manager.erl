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

-export([set_nickname/2, send_message/2, start_client/1]).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_client(UUID) ->
  start_link(UUID).

start_link(UUID) ->
  gen_server:start_link(?MODULE, [UUID], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([UUID]) ->
  case erchat_handler:init(nil, #http_req{bindings=[{uuid, erlang:list_to_binary(UUID)}]}, [], []) of
    {ok, Req2, ErchatState = {ready, _, _}} ->
      {ok, {[ready], ErchatState}};
    {shutdown, Req2, []} ->
      {ok, {[noready], []}}
  end.

handle_call({get, info}, _From, State = {[Status | RestStatuses], ErchatState} ) ->
  {reply, {ok, Status}, RestStatuses};

handle_call({nickname, Nickname}, _From, {ManagerState, ErchatState}) ->
  {ok, Req, NewErchState} = erchat_handler:stream({nickname, Nickname}, nil, ErchatState),
  {reply, ok, {ManagerState, NewErchState}};

handle_call({message, Message}, _From, {ManagerState, ErchatState}) ->
  erchat_handler:stream({message, Message}, nil, ErchatState),
  {reply, ok, {ManagerState, ErchatState}};

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

send_message(Message, Pid) ->
  gen_server:call(Pid, {message, Message}).

set_nickname(Nickname, Pid) ->
  gen_server:call(Pid, {nickname, Nickname}).

get_info(Pid) ->
  gen_server:call(Pid, {get, info}).

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
