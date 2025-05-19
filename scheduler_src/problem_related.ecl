%%% Predicates and definitions related to the problem
%%% Author: Ilias Sakellariou, University of Macedonia, Greece
%%% 2025



%%%% Container and warehouse Info 
/*

container(id,[service_type(Serv),
              wh(ID),
              whname(WName),
              area(AreaID)]).

Serv STRIP/ASIST/STUFF
Type 'KO','ZA', etc.


*/


%%% Assert code arriving from json
%%% Maybe this is to be included in the json parser since it is relatively small.
assert_request_input([]). 

%%% gets a request and finds the area and postion of the warehouse
assert_request_input([container(ID,DATA)|TermList]):-
   member(whName(WareHouseName),DATA),
   convert_warehouse_id(WareHouseID,WareHouseName),
   get_warehouse_area(WareHouseName,Area,Pos),
   member(service_type(ServiceType),DATA),
   assert(container(ID,[service_type(ServiceType),wh(WareHouseID),whName(WareHouseName),area(Area),pos(Pos)])),
   assert_request_input(TermList).

assert_request_input([trucks(Number)|TermList]):-
    asserta(trucks(Number)),
    assert_request_input(TermList).

assert_request_input([reach_stacker_at(WareHouseName)|TermList]):-
    get_warehouse_area(WareHouseName,Area,_Pos),
    asserta(reach_stacker_at(Area)),
    assert_request_input(TermList).

%%% default values for trucks
trucks_number(N):-
    trucks(N),!.

trucks_number(5).

%%% default values for reach stacker
reach_stacker_anywhere(Area):-
    reach_stacker_at(Area),!.

reach_stacker_anywhere(_).






%%% Term Access Predicates
%%% get/3
%%% get(Term,Container,Value)
get(Field,container(_,List),Value):-
    Term =.. [Field,Value],
    member(Term,List),
    !.

%%% fix later
getf(Field,List,Value):-
    Term =.. [Field,Value],
    member(Term,List),
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Code to get the list of warehouses out of container/2 facts.
find_warehouses(ListW):-
  setof(W,Data^CID^(container(CID,Data),
              getf(wh,Data,W)),  
        ListW). 

%%% get the ordered *set* of any field. 
get_from_containers(Field,ListValues):-
  setof(W,Data^CID^(container(CID,Data),
              getf(Field,Data,W)),  
        ListValues). 



/* Maybe later - 
get(service_type,container(_,service_type(Type),_,_,_),Type).
get(cw_type,container(_,_,cw_type(Type),_,_,_),Type).
get(warehouse_number,container(_,_,_,warehouse_number(Num),_),Num).
get(micro_loc,container(_,_,_,_,micro_loc(Loc)),Loc).
*/

%%% Problem Related Definitions
cw_types(['KO', 'ZA', 'OD', 'NA', 'WS']).
service(['STRIP', 'STUFF', 'ASIST']).


convert_types(Type,Code):-
    cw_types(TypeList),
    nth1(Code,TypeList,Type),
    !.

convert_services(Serv,Code):-
    service(TypeList),
    nth1(Code,TypeList,Serv),
    !.


