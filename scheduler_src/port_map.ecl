:-compile('./data/map.ecl').

:-dynamic all_warehouses/1.


%%% Creation of a list of all warehouses associated with
%%% a unique ID. It is in fact creates an enumerated type.
create_list_ws:-
    findall(X,warehouse_data(code(X),_,_,_,_),L),
    retractall(all_warehouses(_)),
    assert(all_warehouses(L)).

:-create_list_ws.


%%% warehouse_domain/1
%%% warehouse_domain(Domain)
%%% Succeeds of Domain is the domain of all warehouses.
warehouse_domain(Domain):-
    all_warehouses(ListW),
    findall(N,member((_,N),ListW),Domain).

%%% Convert ids to Names
%%% warehouses
convert_warehouse_id(ID,Name):-
    all_warehouses(WS),
    member((Name,ID),WS).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Get the area where the warehouse (name) is located.
get_warehouse_area(WareHouseName,Area,Pos):-
    area(Area,_,R1,R2,_),
    (nth1(Pos,R1,WareHouseName)
     ;
     nth1(Pos,R2,WareHouseName)).
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Support Code for finding tour
%%% Row Distance Matrix
%%% Computing the distance matrix between areas of warehouses in port.
%%% creates a row of distancen matrix
create_area_distance_matrix_single_row(A,ListOfAreas, Row):-
    findall(D,(member(Next,ListOfAreas),
               once(area_distance(A,Next,D))
               ),RRow),
     Row =..[[]|RRow].          

%%% Creates a list of lists of distances
%%% WareH is a list of warehouse IDs.
create_area_distance_matrix(ListOfAreas,Matrix):-
    findall(DistArea, (member(A,ListOfAreas),
                      create_area_distance_matrix_single_row(A,ListOfAreas,DistArea)),
                   RawMatrix),
     Matrix =..[[]|RawMatrix].              

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




