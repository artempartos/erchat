-module(erchat_tests).
-include_lib("eunit/include/eunit.hrl").

chat_test() ->
  erchat:start(),
  application:start(erchat_app),
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
