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

-export([set_nickname/2, send_message/2, get_info/1, start_client/1, get_history/1]).
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
    {ok, _Req, ErchatState} ->
      {ok, {[connected], ErchatState}};
    {shutdown, _Req, []} ->
      {ok, {[notconnected], []}}
  end.

handle_call({get, info}, _From, State = {[], _ErchatState} ) ->
  {reply, {ok, []}, State};

handle_call({get, info}, _From, {[Status | RestStatuses], ErchatState} ) ->
  {reply, {ok, Status}, {RestStatuses, ErchatState}};

handle_call({nickname, Nickname}, _From, {ManagerState, ErchatState}) ->
  {reply, {you_logged, _Nick}, _Req, NewErchState} = erchat_handler:event({nickname, Nickname}, nil, ErchatState),
  {reply, ok, {ManagerState, NewErchState}};

handle_call({message, Message}, _From, {ManagerState, ErchatState}) ->
  erchat_handler:event({message, Message}, nil, ErchatState),
  {reply, ok, {ManagerState, ErchatState}};

handle_call({get, history}, _From, {ManagerState, ErchatState}) ->
  {reply, History, _, NewErchatState} = erchat_handler:event({get, <<"history">>}, nil, ErchatState),
  {reply, History, {ManagerState, NewErchatState}};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(Message, {ManagerState, ErchatState}) ->
  {reply, JsonMessage, _Req, NewErchState} = erchat_handler:info(Message, nil, ErchatState),
  {noreply, {[ JsonMessage | ManagerState], NewErchState}};

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

send_message(Message, Pid) ->
  Res = gen_server:call(Pid, {message, Message}),
  timer:sleep(1),
  Res.

set_nickname(Nickname, Pid) ->
  Res = gen_server:call(Pid, {nickname, Nickname}),
  timer:sleep(1),
  Res.

get_history(Pid) ->
  gen_server:call(Pid, {get, history}).

get_info(Pid) ->
  gen_server:call(Pid, {get, info}).

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
