-module(cowboy_tests).
-include_lib("eunit/include/eunit.hrl").


chat_test() ->
  ok = application:start(ranch),
  erchat:start(),
  % code:add_path("../ebin"),
  % code:add_path("../deps/*/ebin"),

  {ok, UUID} = room_sup:create_room(),
  ?assertEqual(erlang:is_list(UUID), true).

% Создать  комнату
% Подключить первого юзера

% Послать сообщение первым юзером

% Подключить второго юзера
% Проверить загрузку истории у второго юзера

% Послать сообщение первым юзером
% Проверить что второй юзер получил сообщение
