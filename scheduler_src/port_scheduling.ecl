%%% Port Scheduling Main App.

%% daily
schedule(daily,TrucksPath,Tour,Cost):-
  get_from_containers(area,ListOfAreas), 
  compute_tour_areas(_,ListOfAreas,Tour,Cost),
  !,
  trucks_number(TrucksNumber),
  truck_allocation(Tour,TrucksNumber,TrucksPath).

%% replan
schedule(replan,TrucksPath,Tour,Cost):-
  (reach_stacker_at(Area) 
      -> true;
      throw(invalid_problem_description("Missing Reach Stacker Position"))
      ),
  !,
  write(['Reach Stacker at area:',Area]),
  get_from_containers(area,ListOfAreas), 
  add_if_missing(Area,ListOfAreas,ListOfAreasFinal,Start),
  compute_tour_areas(Start,ListOfAreasFinal,Tour,Cost),
  !,
  trucks_number(TrucksNumber),
  truck_allocation(Tour,TrucksNumber,TrucksPath).

%%% adds the area if if is missing from the list.
add_if_missing(Area,ListOfAreas,ListOfAreas,Start):-
  nth1(Start,ListOfAreas,Area),!.

add_if_missing(Area,ListOfAreas,[Area|ListOfAreas],1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% compute_tour_areas/4
%%% compute_tour_areas(_,Areas,Tour,Cost)
%%% 
compute_tour_areas(Start,AreaList,Tour,Cost):-
  write(AreaList),nl,
  once(create_area_distance_matrix(AreaList,Matrix)),
  length(AreaList,Len),
  length(Ordering,Len),
  !,
  gfd:(Ordering #::[1..Len+1]),
% reach_stacker_anywhere(Start),
  gfd:ham_path(Start,End,Ordering,Matrix,Cost),
% redundant (could not get any better results)
% gfd:alldifferent(Ordering),
% Using gecode solver search. Best solution in 6 mins
  gfd:search(Ordering, 0, max_regret_upb, split, bb_min(Cost),[timeout(360)]),
  write(['Tour found::',Start,End,Ordering,Cost]),nl,
  !,
  convert_to_tour_areas(Start,End,Ordering,AreaList,Tour).

%%% convert_to_tour_areas/5
%%% convert_to_tour_areas(Start,End,Ordering,WareHouseList,Tour)
%%% Converts the ordering to Warehouse Names.
convert_to_tour_areas(End,End,_,AreaList,[(End,area(Last),Reqs)]):-
    nth1(End,AreaList,Last),
    once(get_warehouse_requests_on_area(Last,Reqs)),
%   once(convert_warehouse_id(Last,WareHouseName)),
    !.

convert_to_tour_areas(Current,End,Ordering,AreaList,[(Current,area(CurrentW),Reqs)|RestTour]):-
    nth1(Current,Ordering,Next),
    nth1(Current,AreaList,CurrentW),
    once(get_warehouse_requests_on_area(CurrentW,Reqs)),
    convert_to_tour_areas(Next,End,Ordering,AreaList,RestTour).

%%% Gets the requests in each specific area.
%%% Uses asserted facts to located container IDs that are 
%%% to be handled in the same row. 
%%% get_warehouse_requests_on_areas(A,WS)
%%% A is the area, and WS is a list of (id(),wh(WiD))
get_warehouse_requests_on_area(A,WS):-
  findall(deliver(pos(P),id(ID),wh(W),whname(WName)),
         (container(ID,Data),once(
               (getf(area,Data,A),
                getf(wh,Data,W),
                getf(whName,Data,WName),
                getf(pos,Data,P)
               )
             )
          ),
         WSTemp),
    sort(WSTemp,WS).     


%%% this will work later.
get_orders(OrderList):-
    findall((CList,O),
      (setof(CID,
            S^T^container(CID, [service_type(S), cw_type(T), order_batch(O)]),
            CList)       
               ), OrderList).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% truck_allocation/3
truck_allocation(ListOfDeliveries,TrucksNumber,TrucksPath):-
      delivery_order(ListOfDeliveries, Ordered),
      write(Ordered),nl,
      test_allocation(Ordered,TrucksNumber,TrucksPath).

%%% place all in order
delivery_order([],[]).
delivery_order([(_,area(_),List)|Rest],Answer):-
  findall((id(ID),whname(WName),wh(WID)),
       member(deliver(pos(_), id(ID), wh(WID), whname(WName)),List),
       Collected),
  delivery_order(Rest,RestLists),
  append(Collected,RestLists,Answer).
   
%%% BAD will fix later
/*  Generates a list of the following form.                       
    [truck(id(tr1),P1),
    truck(id(tr2),P2),
    truck(id(tr3),P3),
    truck(id(tr4),P4),
    truck(id(tr5),P5)
    ]):-
*/                           
test_allocation(Ordered,TrucksNumber, TruckTermsAns):-
    once(int_range(1,TrucksNumber,IntList)),
    findall([],member(_,IntList),EmptyLists),
    allocate(Ordered,EmptyLists,Ans),
    gen_truck_output(Ans,1,TruckTermsAns).

%%% allocate/3
%%% Very basic allocation to trucks.
allocate([],Ans,Ans).
allocate([(id(ID),whname(WName),_)|Ordered],[OldPath|AnsPaths],Ans):-
  container(ID,DATA),
  getf(service_type,DATA,SRVTYPE),
  path_to_service(SRVTYPE,ID,WName,Path),  
  append(OldPath,[Path],NewPath),
  append(AnsPaths,[NewPath],NewAnsPaths),
  allocate(Ordered,NewAnsPaths,Ans).

%%% Fix Path according to service.
path_to_service('STRIP',ID,WName,[id(ID),docks,WName]):-!.
path_to_service('STUFF',ID,WName,[id(ID),empty_containers_dock,WName]):-!.

%%% gen_truck_output/3
%%% gen_truck_output(Paths,N,TruckTerms)
%%% generates truck Terms from a list of Paths.
gen_truck_output([],_,[]).
gen_truck_output([Path|RestPaths],N,[truck(id(Name),Path)|RestTrucks]):-
  gen_truck_name(N,Name),
  NN is N + 1,
  gen_truck_output(RestPaths,NN,RestTrucks).

%%% Just to generate names
gen_truck_name(N,Name):-
  concat_atom([tr,N],Name).

%%% UTILITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% getTermArgfromList(List,N,AnswerList)

get_term_arg_from_list([],_,[]).
get_term_arg_from_list([Term|List],N,[Arg|AnswerList]):-
  arg(N,Term,Arg), 
  get_term_arg_from_list(List,N,AnswerList).


int_range(High,High,[High]).
int_range(Low,High,[Low|Rest]):-
  Low < High,
  NLow is Low + 1, 
  int_range(NLow,High,Rest).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CODE FOR LATER POSSIBLY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TSP only on warehouse locations
% Could be used late
% find_warehouses(ListW), 
% compute_tour(ListW,Tour,Cost).
/* ***************************************************
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% TSP / gfd solver
%%% compute_tour/3
%%% compute_tour(WareHouseList,Tour,Cost)
%%% Succeeds given a list of warehouses WarehouseList, by returning 
%%% a tour of the warehouses of minimum length. 
compute_tour(WareHouseList,Tour,Cost):-
  write(WareHouseList),nl,
  %once(create_distance_matrix(WareHouseList,Matrix)),

  length(WareHouseList,Len),
  length(Ordering,Len),
  !,
  gfd:(Ordering #::[1..Len+1]),
  gfd:ham_path(Start,End,Ordering,Matrix,Cost),
% redundant (could not get any better results)
% gfd:alldifferent(Ordering),
  
% Using gecode solver search. Best solution in 6 mins
  gfd:search(Ordering, 0, max_regret_upb, split, bb_min(Cost),[timeout(360)]),
  write([Start,End,Ordering,Cost]),nl,
  !,
  convert_to_tour(Start,End,Ordering,WareHouseList,Tour).

%%% convert_to_tour/5
%%% convert_to_tour(Start,End,Ordering,WareHouseList,Tour)
%%% Converts the ordering to Warehouse Names.
convert_to_tour(End,End,_,WareHouseList,[(End,Last,WareHouseName)]):-
    nth1(End,WareHouseList,Last),
     once(convert_warehouse_id(Last,WareHouseName)),
    !.

convert_to_tour(Current,End,Ordering,WareHouseList,[(Current,CurrentW,WareHouseName)|RestTour]):-
    nth1(Current,Ordering,Next),
    nth1(Current,WareHouseList,CurrentW),
    once(convert_warehouse_id(CurrentW,WareHouseName)),
    convert_to_tour(Next,End,Ordering,WareHouseList,RestTour).

 */   