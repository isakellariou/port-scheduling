:-module(port_json_interface).

:- export parse_json_request/2.
:- export encode_json/4.
:- export encode_json/2.

:-lib(json).
:-lib(fromonto).

%%% top level
%%% Top level predicate to extract JSON info from request.
%%% parse_json_request/2
%%% parse_json_request(JSONString,Terms)
%%% Throws errors thus should be executed in a catch.
parse_json_request(JSONString,Terms):-
     json_read(input, JsonTerm, [names_as_atoms]) from_string JSONString,
     write('Parsing String OK'),nl,
%    write(JsonTerm),nl,
     (parse_json_container_description(JsonTerm,Terms) -> true; throw(invalid_json_request)),
     !,
     write('JSON Conversion to Terms Generated'),nl.

%%% parse_json_tsn_description/2 
%%% parse_json_tsn_description(JsonTerm,Terms)
%%% Parses a Json Prolog Term as converted by the json lib predicate 
%%% to a list of terms required for the scheduler.
parse_json_container_description({JsonList},ListTerms):-
    extract_info(JsonList,ListTermsNonFlat),
    flatten(ListTermsNonFlat,ListTerms).
    %findall(T,(member(X,StringTerms),flat_string_term(X,T)),Terms).

%%% extract_info/1
%%% extract_info(JsonList)
%%% Extract (recursively) information on all list items appearing 
%%% in the description. Succeeds if description is correct. 
extract_info([],[]).
extract_info([Item|Rest],[ItemTerm|RestItems]):-
      parse_json_item(Item,ItemTerm),
      extract_info(Rest,RestItems).

%%% Top json obcjects
parse_json_item(containers:Containers,ContTerms):-
    parse_container_item(Containers,ContTerms).

parse_json_item(trucks:Number,trucks(Number)).

parse_json_item(reach_stacker_at:WHNAME_STR,reach_stacker_at(WHNAME)):-   
    atom_string(WHNAME,WHNAME_STR).


%%% parsing the list of container items
parse_container_item([],[]):-!.

parse_container_item([{ContainerDesc}|Rest],[container(CID,DATA)|RestTerms]):-
    once(member(id:CID,ContainerDesc)),
    
    member(service_type:SRVTYPE_STR,ContainerDesc),
    atom_string(SRVTYPE,SRVTYPE_STR),

    member(warehouse:WHNAME_STR,ContainerDesc),
    atom_string(WHNAME,WHNAME_STR),
% change - no like -bad style
    DATA = [service_type(SRVTYPE),whName(WHNAME)],
    
    parse_container_item(Rest,RestTerms).



%%% add_data/1
%%% add_data(Term)
%%% adds data from Json Description where needed (modularity)
% No Debug
add_data(_):-!.
/* To be used later
add_data(Term):-
    write('From add data '),
    flat_string_term(Term,FlatTerm),
    writeq(FlatTerm),nl. 
*/

%%% Flat Strings to Terms.
flat_string_term(Term,FlatTerm):-
    Term =.. [Func|Args],
    findall(FT,(member(T,Args),flat(T,FT)),FlatArgs),
    FlatTerm =..[Func|FlatArgs].

%%% Flat Strings, numbers, Lists.
flat([],[]).
flat(T,FT):-string(T), !, atom_string(FT,T).
flat(T,T):-number(T),!.
flat([T|Rest],[FT|RestFT]):-
    flat(T,FT), 
    flat(Rest,RestFT).    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Prolog to JSON
%%% type taprio/omnet
%%% The following code accepts a list of Prolog terms and converts them
%%% to a json prolog terms, o be handled by the Json library.

%%% encode_json/4
%%% encode_json(Type,AnswerTerms,Flows,Answer)
%%% Encodes to a Answer a JsonString that is the answer to the request. 
%%% Type can be either taprio or omnet, depending on the target tsn platform
%%% Answer also contains information regarding the scheduled flows. 

%%% Used in testing
encode_json('ok',Answer):-
       json_write(output,{status:'test_ok'},[indent(0)]) onto_string Answer.


encode_json(Type,ReachStackerPath,Trucks,Answer):-
   member(Type,[daily,replan]),
   reach_stacker_json(ReachStackerPath,JSonStructure),
   trucks_json(Trucks,TruckScheduleJson),
   json_write(output,{reach_stacker:JSonStructure, trucks:TruckScheduleJson},[indent(0)]) onto_string Answer.


reach_stacker_json([],[]).
reach_stacker_json([(_,area(_),DeliveryList)|RestEntries],DeliveryAnswer):-
    delivery_list_json(DeliveryList,JsonDevList),
    reach_stacker_json(RestEntries,RestJson),
    append(JsonDevList,RestJson,DeliveryAnswer).


delivery_list_json([],[]).
delivery_list_json([deliver(_,id(CID),_,whname(WareHouseName))|DeliveryList],
                   [{container:CID,warehouse:WareHouseName}|JsonDevList]):-
        delivery_list_json(DeliveryList,JsonDevList).

%%
trucks_json([],[]).
trucks_json([truck(id(TRID),TruckAlloc)|RestTrucks],
            [{truck:TRID, path:List}|RestJsonTruckInfo]):-
          findall({container:ID,start:Start,end:End},
                 member([id(ID),Start,End],TruckAlloc),
                 List),
          trucks_json(RestTrucks,RestJsonTruckInfo).

