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

-export([get_history/1, login_user/2, get_users_count/1, get_users/1,
         kick_user/2]).
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

handle_call({kick, Nick}, _From, State) ->
  {UUID, Users, History} = State,
  NewUsers = lists:delete(Nick, Users),
  broadcast({kick, Nick}, UUID),
  {reply, ok, {UUID, NewUsers, History}};
handle_call({get, users}, _From, State) ->
  {_UUID, Users, _History} = State,
  {reply, {users, Users}, State};
handle_call({get, history}, _From, State) ->
  {_UUID, _Users, History} = State,
  {reply, {history, lists:reverse(History)}, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({new_user, Nick}, State) ->
  {UUID, Users, History} = State,
  Message = {login, Nick},
  broadcast(Message, UUID),
  NewState = {UUID,[Nick | Users], History},
  {noreply, NewState};

handle_cast({new_message, Nick, Message}, State) ->
  {UUID, Users, History} = State,
  NewMessage = [{nick, Nick}, {content, Message}],
  ResponseMessage = {message, NewMessage},
  NewHistory = [NewMessage | History],
  NewState = {UUID, Users, NewHistory},
  broadcast(ResponseMessage, UUID),
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
  gen_server:call(Pid, {get, history}).

login_user(RoomPid, Nick) ->
  gen_server:cast(RoomPid, {new_user, Nick}).

get_users(RoomPid) ->
  gen_server:call(RoomPid, {get, users}).

get_users_count(RoomPid) ->
  {users, Users} = get_users(RoomPid),
  length(Users).

kick_user(RoomPid, Nick) ->
  gen_server:call(RoomPid, {kick, Nick}).

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

