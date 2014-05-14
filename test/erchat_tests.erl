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
  {ok, Pid2} = erchat_manager:start_client(UUID),
  {ok, Info1} = erchat_manager:get_info(Pid1),
  {ok, Info2} = erchat_manager:get_info(Pid2),

  ?assertEqual(Info1, ready),
  ?assertEqual(Info2, ready),

  Pids = [Pid || {Pid, _} <- gproc:lookup_local_properties(UUID)],

  ?assertEqual([Pid1, Pid2], Pids),

  Message = "Yahoo",
  Nick = "Guffi",

  ok = erchat_manager:set_nickname(Nick, Pid1),
  ok = erchat_manager:send_message(Message, Pid1),

  timer:sleep(1),

  {ok, ExpectedMessage} = erchat_manager:get_info(Pid1),
  ?assertEqual({message, Nick, Message}, ExpectedMessage).


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



