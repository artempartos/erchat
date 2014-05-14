-module(rooms_server).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

-export([get_room_pid/1, get_rooms/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(Args) ->
  {ok, Args}.

handle_call({get, rooms}, _From, Rooms) ->
  {reply, Rooms, Rooms};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast({new_room, UUID, _Pid}, State) ->
  %% save to state
  {noreply, [UUID | State]};

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

get_room_pid(UUID) ->
  _PID = gproc:lookup_local_name(UUID).

get_rooms() ->
  gen_server:call(?MODULE, {get, rooms}).
%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
