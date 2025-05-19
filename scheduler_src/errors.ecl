%%% Error handling for the port scheduler Scheduler. 
:-module(errors).

:-lib(json).
:-lib(fromonto).

:- export sched_manage_errors/3.

sched_manage_errors(invalid_json_format,401,Answer):-!,
    json_format(401,"Invalid json format received.", Answer).

 sched_manage_errors(error(syntax_error("unexpected token"),_),401,Answer):-!,
    json_format(401,"Invalid json format received.", Answer).

sched_manage_errors(invalid_json_request,402,Answer):-!,
    json_format(402,"Invalid json scheduler request received.",Answer).

sched_manage_errors(invalid_network_description(Cause),403,Answer):-
    string_concat("Invalid Container description - ",Cause,Message),!,
    json_format(403,Message,Answer).

sched_manage_errors(invalid_problem_description(Cause),404,Answer):-
    string_concat("Invalid Problem description - ",Cause,Message),!,
    json_format(404,Message,Answer).




%%% This is not typically an error, 
%%% should change code to handle this differently.
sched_manage_errors(solution_not_found,201,Answer):-
    !,
    json_format(201,"Solution not found to the Request.",Answer).

sched_manage_errors(ERR,498,Answer):-
    sprintf(Message,"Unhandled code exception:  %w", ERR),
    json_format(498,Message,Answer).

%%% Convert to JSON
%%% Gets a Code and a Sting Message and forms the JOSN for output.
json_format(Code,Message,Answer):-
     json_write(output,{code:Code, message:Message},[indent(0)]) onto_string Answer.