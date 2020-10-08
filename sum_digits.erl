-module(sum_digits).
-export([start/0, stop/0, count/1, init/0]).

% count_sum(0) ->	0;
% count_sum(N) when N > 0 -> N rem 10 + count_sum(N div 10).

% count_sum_total(N) when N >= 0, N < 10 -> N;
% count_sum_total(N) when N >= 10 -> count_sum_total(count_sum(N)); 
% count_sum_total(_) -> io:fwrite("Wrong number!~n", []).

count_sum_total(0, Sum) -> 	Sum;
count_sum_total(N, Sum) when Sum >= 10 -> 
	count_sum_total(N, (Sum rem 10) + 1);
count_sum_total(N, Sum) when Sum < 10 ->
	count_sum_total(N div 10, Sum + N rem 10);
count_sum_total(_, _) ->
	io:fwrite("Wrong argument!~n", []).

start() -> register(sum_digits, spawn(sum_digits, init, [])).

init() -> loop().

stop() -> call(stop).

count(Number) -> call({number, Number}).

call(Request) ->
    sum_digits ! {request, self(), Request},
	receive
		{reply, Reply} -> Reply
	end.

reply(To, Request) ->
    To ! {reply, Request}.

loop() ->
	receive
		{request, From, {number, Number}} ->
			Sum = count_sum_total(Number, 0),
			reply(From, Sum),
			loop();
		{request, From, stop} ->
			reply(From, stop)
	end.


