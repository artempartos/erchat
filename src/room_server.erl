-module(room_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-export([get_history/1]).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link(Args) ->
  gen_server:start_link(?MODULE, [Args], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init([UUID]) ->
  %%true = gproc:reg({n, l, UUID}, [self()]),
  Users = [],
  History = [],
  {ok, {UUID, Users, History}}.

handle_call({get, history}, _From, State) ->
  {_UUID, _Users, History} = State,
  {reply, History, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({new_message, Nickname, Message}, State) ->
  {UUID, Users, History} = State,
  NewMessage = {message, Nickname, Message},
  NewHistory = [NewMessage | History],
  NewState = {UUID, Users, NewHistory},
  broadcast(NewMessage, UUID),
  {noreply, NewState};

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

broadcast(Message, UUID) ->
  gproc:send({p,l, UUID}, Message).

get_history(Pid) ->
  lists:reverse(gen_server:call(Pid, {get, history})).

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

