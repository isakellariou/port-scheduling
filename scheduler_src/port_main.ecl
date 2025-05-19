%%% Port Scheduling 
%%% Author: Ilias Sakellariou, University of Macedonia, Greece
%%% 2025

:-module(port_main).

%% :-export answer_json_request/3. 
:-export answer_json_request/4. 

:-use_module(port_json_interface).
:-use_module(errors).
  
%% Libs  
:-lib(ic).
:-lib(ic_global).
:-lib(propia).

:-lib(listut). 
:-lib(gfd).

:-lib(branch_and_bound).
%%% Include Files

%% Uncomment when ready for deployment.
:-use_module('http_server_v11/http_server_v11.pl').
%%% Load all files at start/avoid error.json 
:-include('problem_related.ecl').
:-include('port_map.ecl').
:-include('port_scheduling.ecl'). 


%%% Dymanic struct and clear predicate
:-dynamic container/2.
:-dynamic trucks/1.
:-dynamic reach_stacker_at/1.

%%% just to have a point for clearing everything.
clear_all:-
    retractall(container(_,_)),
    retractall(trucks(_)),
    retractall(reach_stacker_at(_)).


%%% %%% answer_json_request/4
%%% answer_json_request(Type,JsonString,Code, Answer)
%%% Answers json request comming from http_method/6.
%%% Formats answer in json with respect to the type of request (taprio/omnet)

answer_json_request(Type,JsonString,Code, Answer):-
    catch( (answer_json_request(Type,JsonString,Answer),Code = 200),
        ERROR,
        sched_manage_errors(ERROR,Code,Answer)).
    

%%% answer_json_request/3
%%% answer_json_request(Type,JsonString,Answer)
%%% Answers json request comming from http_method/6.
%%% Formats answer in json with respect to the type of request 
answer_json_request(Type,JsonString,Answer):-
    parse_json_request(JsonString,ContainerInfoTerms),
    clear_all,
    assert_request_input(ContainerInfoTerms),
    write('Container Info Asserted!'),nl,
    (listing), 
    (schedule(Type,TruckPath,Tour,Cost) ->
        true;
        throw(solution_not_found)),
    write(TruckPath),nl,
    write(Tour),nl,
    write(Cost),nl,
% Checking whether the network description is consistent    
%  check_network_in_request,
% compute_tsn_schedule(Type,AnswerTerms,FlowInfo),
%    (tsn_schedule(Schedule,input_order,indomain_min) -> true ; throw(solution_not_found)),
%    write('Schedule Found.'),nl,
    
    encode_json(Type,Tour,TruckPath,Answer),
    write('Answer Encoded.'),nl,
    true.






