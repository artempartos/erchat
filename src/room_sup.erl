-module(room_sup).
-behaviour(supervisor).

-export([start_link/0, init/1, create_room/0]).

-define(CHILD(I, Type), {I, {I, start_link, []}, temporary, 5000, Type, [I]}).

start_link() ->
  ok, _ = supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(_Arg) ->
  {ok, {{simple_one_for_one, 5, 10},
  [?CHILD(room_server, worker)]}}.

create_room() ->
  UUID = uuid:to_string(uuid:uuid1()),
  {ok, Pid} = supervisor:start_child(?MODULE, [UUID]),
  gen_server:cast(rooms_server, {new_room, UUID, Pid}),
  {ok, UUID}.