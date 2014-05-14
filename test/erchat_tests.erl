-module(erchat_tests).
-include_lib("eunit/include/eunit.hrl").

-compile(export_all).

erchat_test_() ->
  {foreach,
   fun start/0,
   fun stop/1,
     [fun test_chat/0,
      fun test_rooms/0]}.

start() ->
  erchat:start(),
  application:start(erchat_app).

stop(_) ->
  application:stop(erchat_app),
  erchat:stop().


test_chat() ->
  {ok, UUID} = erchat:create_room(),
  RoomPid = rooms_server:get_room_pid(UUID),

  ?assert(erlang:is_pid(RoomPid)),
  ?assert(erlang:is_list(UUID)),

  {ok, Pid1} = erchat_manager:start_client(UUID),
  {ok, Info1} = erchat_manager:get_info(Pid1),
  ?assertEqual(Info1, connected),
  
  Message = "Yahoo",
  Nick = "Guffi",
  ok = erchat_manager:set_nickname(Nick, Pid1),
  ok = erchat_manager:send_message(Message, Pid1),
  {ok, Message1} = erchat_manager:get_info(Pid1),
  ?assertEqual({message, Nick, Message}, Message1),

  {ok, Pid2} = erchat_manager:start_client(UUID),
  {ok, Info2} = erchat_manager:get_info(Pid2),
  ?assertEqual(Info2, connected),
  {ok, History} = erchat_manager:get_info(Pid2),
  ?assertEqual([{message, Nick, Message}], History),
  
  Pids = [Pid || {Pid, _} <- gproc:lookup_local_properties(UUID)],
  ?assertEqual([Pid1, Pid2], Pids),

  ok = erchat_manager:send_message("Not sended", Pid2),
  {ok, []} = erchat_manager:get_info(Pid1),
  ok = erchat_manager:set_nickname("Nick2", Pid2),
  ok = erchat_manager:send_message("Hallo!", Pid2),
  {ok, Message2} = erchat_manager:get_info(Pid1),

  {ok, Pid3} = erchat_manager:start_client(UUID),
  {ok, Info3} = erchat_manager:get_info(Pid3),
  {ok, History2} = erchat_manager:get_info(Pid3),
  ?assertEqual([Message1, Message2], History2).



% Создать  комнату
% Подключить первого юзера

% Послать сообщение первым юзером

% Подключить второго юзера
% Проверить загрузку истории у второго юзера

% Послать сообщение первым юзером
% Проверить что второй юзер получил сообщение

test_rooms() ->
  {ok, RoomUUID1} = erchat:create_room(),
  {ok, RoomUUID2} = erchat:create_room(),

  Rooms = rooms_server:get_rooms(),

  ?assert(erlang:is_list(Rooms)),
  ?assertEqual(Rooms, [RoomUUID2, RoomUUID1]).



