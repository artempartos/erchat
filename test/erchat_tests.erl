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
  Pid = rooms_server:get_room_pid(UUID),

  ?assert(erlang:is_pid(Pid)),
  ?assert(erlang:is_list(UUID)),
  {ok, Pid2} = erchat_manager:start_link(UUID),
  {ok, ready} = gen_server:call(Pid2, {get, info}),
  ?assert(erlang:is_list(UUID)).


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

