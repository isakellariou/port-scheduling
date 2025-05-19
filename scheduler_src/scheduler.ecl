%%% scheduler.ecl


%% port scheduler top level 

%% Uncomment when ready for deployment.
:-use_module('http_server_v11/http_server_v11.pl').
%%% Load all files at start/avoid error.json 
:-compile('http_method').
:-compile('port_json_interface.ecl').
:-compile('port_main.ecl').


%%% Not much here... just run the service on 8080.
run_port_scheduler:-
    http_server(8080).


%%% testCode for developement
%%% Comment out 
file(0,'./json_requests/test5.json').
file(1,'./json_requests/test10.json').
file(2,'./json_requests/test100.json').
file(3,'./json_requests/test300.json').
file(4,'./json_requests/test500.json').


run_test_file(Type,FileN,Code,Answer):-
    file(FileN,FileDesc),
    open(FileDesc,read,S), 
    read_string(S,_,JsonString),
    port_main:answer_json_request(Type,JsonString,Code, Answer).