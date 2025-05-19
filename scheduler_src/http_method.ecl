
/*
 http_method.ecl file for the NEPHELE open source minimal Port scheduler. 
 Contributor(s): Ilias Sakellariou 2025
 
 The file contains the implementation of the http_method called by 
 the ECLiPse Prolog http_server, following the original structure 
 found in the ECLiPSe Constraint Programming Langauge documentation, 
 and in particular to the file:
 
 http_method.pl,v 1.2 2011/04/01 05:58:07 jschimpf 

*/

:- module(http_method).

:- export
        http_method/6.

%%% Module for answering Scheduling Requests
%%% 
:-use_module(port_main).

http_method("GET", "/port_schedule/daily", ObjectBody, Contents, Code, [contentType(mt(application,json)),contentLength(CL)]):-
    answer_json_request(daily,ObjectBody,Code,Contents),!,
    string_length(Contents, CL).


http_method("GET", "/port_schedule/replan", ObjectBody, Contents, Code, [contentType(mt(application,json)),contentLength(CL)]):-
    answer_json_request(replan,ObjectBody,Code,Contents),!,
    string_length(Contents, CL).

%%% Entrypoint for heathcheck in Docker Compose.
http_method("GET", "/port_schedule/health", _, Contents, 200, [contentLength(CL)]):-
    Contents = "OK",
    string_length(Contents, CL).

%% Invalid Request
http_method("GET", _, _, Contents, 499, [contentLength(CL)]):-
    Contents = "Some Error Occured.",
    string_length(Contents,CL).
	    
