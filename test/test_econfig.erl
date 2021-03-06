-module(test_econfig).
-include_lib("eunit/include/eunit.hrl").

setup() ->
    ok = application:load(econfig),
    ok = econfig:start(),
    ?cmd("cp ../priv/fixtures/test*.ini ./"),
    ok = econfig:register_config(t, ["test3.ini"], []).

cleanup(_State) ->
    ok = application:stop(econfig),
    ok = application:unload(econfig),
    ?cmd("rm test*.ini"),
    ok = application:stop(gproc).

parse_test_() ->
    {setup,
     fun setup/0,
     fun cleanup/1,
     [
      ?_assertEqual(true,
                    econfig:get_bool(t, "bool_section", "key1")),
      ?_assertEqual(false,
                    econfig:get_bool(t, "bool_section", "key2")),
      ?_assertEqual(false,
                    econfig:get_bool(t, "bool_section", "key3")),
      ?_assertThrow({econfig_error, "t.bool_section.key4 wait for boolean but got \"bla-bla-bla\""},
                    econfig:get_bool(t, "bool_section", "key4")),

      ?_assertEqual(0,
                    econfig:get_int(t, "int_section", "key1")),
      ?_assertEqual(-100,
                    econfig:get_int(t, "int_section", "key2")),
      ?_assertEqual(100,
                    econfig:get_int(t, "int_section", "key3")),
      ?_assertThrow({econfig_error, "t.int_section.key4 wait for integer but got undefined"},
                    econfig:get_int(t, "int_section", "key4")),
      ?_assertThrow({econfig_error, "t.int_section.key5 wait for integer but got \"bla-bla-bla\""},
                    econfig:get_int(t, "int_section", "key5")),

      ?_assertEqual(5.5,
                    econfig:get_float(t, "float_section", "key1")),
      ?_assertThrow({econfig_error, "t.float_section.key2 wait for float but got \"5\""},
                    econfig:get_float(t, "float_section", "key2")),
      ?_assertThrow({econfig_error, "t.float_section.key3 wait for float but got \"5.\""},
                    econfig:get_float(t, "float_section", "key3")),
      ?_assertEqual(5.0,
                    econfig:get_float(t, "float_section", "key4")),
      ?_assertThrow({econfig_error, "t.float_section.key5 wait for float but got \"5.0.\""},
                    econfig:get_float(t, "float_section", "key5")),
      ?_assertEqual(-33.78,
                    econfig:get_float(t, "float_section", "key6")),
      ?_assertThrow({econfig_error, "t.float_section.key7 wait for float but got undefined"},
                    econfig:get_float(t, "float_section", "key7")),
      ?_assertThrow({econfig_error, "t.float_section.key8 wait for float but got \"bla-bla-bla\""},
                    econfig:get_float(t, "float_section", "key8")),

      ?_assertEqual(["one", "two", "three"],
                    econfig:get_list(t, "list_section", "key1")),
      ?_assertEqual(["Bob", "Bill", "Helen"],
                    econfig:get_list(t, "list_section", "key2")),
      ?_assertEqual([],
                    econfig:get_list(t, "list_section", "key3")),
      ?_assertEqual(["apple"],
                    econfig:get_list(t, "list_section", "key4")),
      ?_assertEqual(["apple"],
                    econfig:get_list(t, "list_section", "key5")),
      ?_assertEqual(["apple", "banana"],
                    econfig:get_list(t, "list_section", "key6")),
      ?_assertEqual(["apple", "banana"],
                    econfig:get_list(t, "list_section", "key7")),
      ?_assertEqual(["apple", "banana"],
                    econfig:get_list(t, "list_section", "key8")),
      ?_assertEqual(["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
                    econfig:get_list(t, "list_section", "key9")),

      ?_assertEqual("true",
                    econfig:get_string(t, "bool_section", "key1")),
      ?_assertEqual("false",
                    econfig:get_string(t, "bool_section", "key2")),
      ?_assertEqual(undefined,
                    econfig:get_string(t, "bool_section", "key3")),
      ?_assertEqual("bla-bla-bla",
                    econfig:get_string(t, "bool_section", "key4")),

      ?_assertEqual(<<"true">>,
                    econfig:get_binary(t, "bool_section", "key1")),
      ?_assertEqual(<<"false">>,
                    econfig:get_binary(t, "bool_section", "key2")),
      ?_assertEqual(undefined,
                    econfig:get_binary(t, "bool_section", "key3")),
      ?_assertEqual(<<"bla-bla-bla">>,
                    econfig:get_binary(t, "bool_section", "key4"))
     ]}.
