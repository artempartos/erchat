-module(erchat_tests).
-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

erchat_test_() ->
  {foreach,
   fun start/0,
   fun stop/1,
     [fun test_history/0,
      fun test_send_message/0,
      fun test_send_message_without_nick/0,
      fun test_client_connected_and_login/0,
      fun test_save_room/0,
      fun test_users/0,
      fun test_get_rooms/0]}.

start() ->
  application:set_env(erchat, port, 8005),
  erchat:start().

stop(_) ->
  erchat:stop().

test_client_connected_and_login() ->
  {ok, UUID} = erchat:create_room(),
  {ok, Client} = erchat_manager:start_client(UUID),

  {ok, Info} = erchat_manager:get_info(Client),
  ?assertEqual(Info, connected),

  Nick = "Guffi",
  ok = erchat_manager:set_nickname(Nick, Client),
  ExpectedLogin = encode_message({login, Nick}),
  {ok, Login} = erchat_manager:get_info(Client),
  ?assertEqual(ExpectedLogin, Login).

test_send_message() ->
  {ok, UUID} = erchat:create_room(),
  {ok, Client} = erchat_manager:start_client(UUID),
  {ok, connected} = erchat_manager:get_info(Client),

  Nick = "Guffi",
  Message = "Yep!",
  ok = erchat_manager:set_nickname(Nick, Client),
  ExpectedInfo = encode_message({login, Nick}),
  {ok, ExpectedInfo} = erchat_manager:get_info(Client),

  ok = erchat_manager:send_message(Message, Client),
  ExpectedMessage = encode_message({message, [{nick, Nick},{content, Message}]}),
  {ok, Result} = erchat_manager:get_info(Client),
  ?assertEqual(ExpectedMessage, Result).


test_send_message_without_nick() ->
  {ok, UUID} = erchat:create_room(),
  {ok, Client} = erchat_manager:start_client(UUID),
  {ok, connected} = erchat_manager:get_info(Client),
  Message = "Yep!",
  ok = erchat_manager:send_message(Message, Client),
  {ok, Result} = erchat_manager:get_info(Client),
  ?assertEqual([], Result).

test_save_room() ->
  {ok, UUID} = erchat:create_room(),
  RoomPid = rooms_server:get_room_pid(UUID),
  ?assert(erlang:is_pid(RoomPid)),
  ?assert(erlang:is_list(UUID)).


test_history() ->
  {ok, UUID} = erchat:create_room(),
  {ok, Client1} = erchat_manager:start_client(UUID),
  {ok, Client2} = erchat_manager:start_client(UUID),
  Message = "Yep!",
  Nick1 = "Nick1",
  Nick2 = "Nick2",

  ok = erchat_manager:set_nickname(Nick1, Client1),
  ok = erchat_manager:set_nickname(Nick2, Client2),

  ok = erchat_manager:send_message(Message, Client1),
  ok = erchat_manager:send_message(Message, Client2),

  {ok, LastClient} = erchat_manager:start_client(UUID),
  {ok, connected} = erchat_manager:get_info(LastClient),

  {history, History} = erchat_manager:get_history(LastClient),
  ?assertEqual([[{nick, Nick1}, {content, Message}], [{nick, Nick2}, {content, Message}]], History).


test_get_rooms() ->
  {ok, RoomUUID1} = erchat:create_room(),
  {ok, RoomUUID2} = erchat:create_room(),

  Rooms = rooms_server:get_rooms(),

  ?assert(erlang:is_list(Rooms)),
  ?assertEqual(Rooms, [RoomUUID2, RoomUUID1]).

test_users() ->
  {ok, UUID} = erchat:create_room(),
  {ok, Client1} = erchat_manager:start_client(UUID),
  {ok, Client2} = erchat_manager:start_client(UUID),
  Nick1 = "Nick1",
  Nick2 = "Nick2",

  ok = erchat_manager:set_nickname(Nick1, Client1),
  ok = erchat_manager:set_nickname(Nick2, Client2),

  RoomPid = rooms_server:get_room_pid(UUID),
  {users, Users} = room_server:get_users(RoomPid),
  erlang:display(Users),
  ?assertEqual(2, length(Users)).

encode_message({Event, Data}) ->
  jsx:encode([{event, Event}, {data, Data}]).
  
