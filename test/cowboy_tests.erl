-module(cowboy_tests).
-include_lib("eunit/include/eunit.hrl").

cowboy_test_() ->
  {foreach,
   fun start/0,
   fun stop/1,
   [
    fun test_chat/0
   ]}.

start() ->
  erchat:start().

stop(_) ->
  erchat:stop().

test_chat() ->
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
