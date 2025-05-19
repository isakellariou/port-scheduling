%%%% Map data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Implementation Based on Areas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% area(Num,NumRows,Row1,Row2,Encoding)
area(2,2,['Z33A', 'Z33B', 'Z33C', 'Z33D'],
         ['Z32A', 'Z32B', 'Z32C', 'Z32D','Z32E'],north).

area(3,1,['Z30A', 'Z30B', 'Z30C', 'Z31A', 'Z31B', 'Z31C', 'Z34A', 'Z34B', 'Z34C'],
         [], north).

area(4,2,['Z29A', 'Z29B'],
         ['Z21A', 'Z21B', 'Z21C', 'Z21D'],north).
% on map there is Z26C but missing from  data/

area(5,2,['Z27A', 'Z27B', 'Z27C', 'Z27D', 'Z27E', 'Z28A', 'Z28B', 'Z28C'],
         ['Z26A', 'Z26C'],north).

area(6,1,['Z20A', 'Z20B', 'Z20C', 'Z22D', 'Z22A', 'Z22B', 'Z22C'],
         [],north).

area(7,2,['ZS2B','ZS2A'],
         ['Z19', xxxZ18,'Z17B','Z17A'], south).         

area(8,1,['Z16', 'Z14','Z13A', 'Z13B', 'Z13C','NAG1 1B'],
         [], south).         

area(9,1,['NPG', 'NPF', 'NPE', 'NPD', 'NPC', 'NPB', 'NPA'],
         [], south).

area(10,1,['C22', 'C21', 'C19', 'C17', 'C16','C6', 'C7', 'C8', 'C9', 'C10'],
         [], south).

%%% remote areas
area(1,1,['Z50A', 'Z50B', 'Z50C', 'Z50D', 'Z50E', 'Z50F', 'Z50G', 'Z51A', 'Z51B', 'Z51C', 'Z51D', 'Z51E', 'Z51F','ZLT2', 'ZLT3', 'ZLT1'],
         [],flat).

area(11,1,['ZLT7','ZLT6', 'ZLT9', 'ZL4A', 'ZL4B'],
   [],north).

area(12,1,['ZLT8'],
    [], flat).

%%% Unlocated
area(13,1,['ODG2', 'PL50', 'PL53','Z3AP', 'Z3BP'],
    [],flat).
%%%% Area Graph Distances
area_dist(1,12,1).
area_dist(5,12,8).
area_dist(5,11,4).
area_dist(5,3,1).
area_dist(5,6,1).
area_dist(3,11,3).
area_dist(2,3,1).
area_dist(4,2,1).
area_dist(4,7,1).
area_dist(4,5,1).
area_dist(6,4,1).
area_dist(6,8,1).
area_dist(6,9,2).
area_dist(6,10,3).
area_dist(10,9,1).
area_dist(9,8,1).
area_dist(8,7,1).
%%% unknown area
area_dist(5,13,4).
%% disatnce to itself
area_dist(X,X,0).
%%% Computations 
%%% bidirectional distances
area_dist_b(R1,R2,Dist):-
    area_dist(R1,R2,Dist).

area_dist_b(R1,R2,Dist):-
    area_dist(R2,R1,Dist).

%%% get Row Dist
find_area_distance(Row1,Row2,Dist):-
    find_area_distance(Row1,Row2,[Row1],Dist).

find_area_distance(Row1,Row2,_,Dist):-
    area_dist_b(Row1,Row2,Dist).

find_area_distance(Row1,Row2,Past,Dist):-
    area_dist_b(Row1,RowX,DistX),
    not(member(RowX,Past)),
    find_area_distance(RowX,Row2,[RowX|Past],DistNext),
    Dist is DistX + DistNext. 

%%%% Predicate to generate distances
%%% That are shown below.
compute_all_area_distances(RowList):-
    eclipse_language:delete(R1,RowList,Rest),
    member(R2,Rest),
    setof(D,find_area_distance(R1,R2,D),[Dist|_]),
    write(area_distance(R1,R2,Dist)),write('.'),nl,
    fail.

%%% Computed Distances
%%% Precomputed distances of all areas given the code above.
%%% 
area_distance(X,X,0).
area_distance(1, 2, 11).
area_distance(1, 3, 10).
area_distance(1, 4, 10).
area_distance(1, 5, 9).
area_distance(1, 6, 10).
area_distance(1, 7, 11).
area_distance(1, 8, 11).
area_distance(1, 9, 12).
area_distance(1, 10, 13).
area_distance(1, 11, 13).
area_distance(1, 12, 1).
area_distance(1, 13, 13).
area_distance(2, 1, 11).
area_distance(2, 3, 1).
area_distance(2, 4, 1).
area_distance(2, 5, 2).
area_distance(2, 6, 2).
area_distance(2, 7, 2).
area_distance(2, 8, 3).
area_distance(2, 9, 4).
area_distance(2, 10, 5).
area_distance(2, 11, 4).
area_distance(2, 12, 10).
area_distance(2, 13, 6).
area_distance(3, 1, 10).
area_distance(3, 2, 1).
area_distance(3, 4, 2).
area_distance(3, 5, 1).
area_distance(3, 6, 2).
area_distance(3, 7, 3).
area_distance(3, 8, 3).
area_distance(3, 9, 4).
area_distance(3, 10, 5).
area_distance(3, 11, 3).
area_distance(3, 12, 9).
area_distance(3, 13, 5).
area_distance(4, 1, 10).
area_distance(4, 2, 1).
area_distance(4, 3, 2).
area_distance(4, 5, 1).
area_distance(4, 6, 1).
area_distance(4, 7, 1).
area_distance(4, 8, 2).
area_distance(4, 9, 3).
area_distance(4, 10, 4).
area_distance(4, 11, 5).
area_distance(4, 12, 9).
area_distance(4, 13, 5).
area_distance(5, 1, 9).
area_distance(5, 2, 2).
area_distance(5, 3, 1).
area_distance(5, 4, 1).
area_distance(5, 6, 1).
area_distance(5, 7, 2).
area_distance(5, 8, 2).
area_distance(5, 9, 3).
area_distance(5, 10, 4).
area_distance(5, 11, 4).
area_distance(5, 12, 8).
area_distance(5, 13, 4).
area_distance(6, 1, 10).
area_distance(6, 2, 2).
area_distance(6, 3, 2).
area_distance(6, 4, 1).
area_distance(6, 5, 1).
area_distance(6, 7, 2).
area_distance(6, 8, 1).
area_distance(6, 9, 2).
area_distance(6, 10, 3).
area_distance(6, 11, 5).
area_distance(6, 12, 9).
area_distance(6, 13, 5).
area_distance(7, 1, 11).
area_distance(7, 2, 2).
area_distance(7, 3, 3).
area_distance(7, 4, 1).
area_distance(7, 5, 2).
area_distance(7, 6, 2).
area_distance(7, 8, 1).
area_distance(7, 9, 2).
area_distance(7, 10, 3).
area_distance(7, 11, 6).
area_distance(7, 12, 10).
area_distance(7, 13, 6).
area_distance(8, 1, 11).
area_distance(8, 2, 3).
area_distance(8, 3, 3).
area_distance(8, 4, 2).
area_distance(8, 5, 2).
area_distance(8, 6, 1).
area_distance(8, 7, 1).
area_distance(8, 9, 1).
area_distance(8, 10, 2).
area_distance(8, 11, 6).
area_distance(8, 12, 10).
area_distance(8, 13, 6).
area_distance(9, 1, 12).
area_distance(9, 2, 4).
area_distance(9, 3, 4).
area_distance(9, 4, 3).
area_distance(9, 5, 3).
area_distance(9, 6, 2).
area_distance(9, 7, 2).
area_distance(9, 8, 1).
area_distance(9, 10, 1).
area_distance(9, 11, 7).
area_distance(9, 12, 11).
area_distance(9, 13, 7).
area_distance(10, 1, 13).
area_distance(10, 2, 5).
area_distance(10, 3, 5).
area_distance(10, 4, 4).
area_distance(10, 5, 4).
area_distance(10, 6, 3).
area_distance(10, 7, 3).
area_distance(10, 8, 2).
area_distance(10, 9, 1).
area_distance(10, 11, 8).
area_distance(10, 12, 12).
area_distance(10, 13, 8).
area_distance(11, 1, 13).
area_distance(11, 2, 4).
area_distance(11, 3, 3).
area_distance(11, 4, 5).
area_distance(11, 5, 4).
area_distance(11, 6, 5).
area_distance(11, 7, 6).
area_distance(11, 8, 6).
area_distance(11, 9, 7).
area_distance(11, 10, 8).
area_distance(11, 12, 12).
area_distance(11, 13, 8).
area_distance(12, 1, 1).
area_distance(12, 2, 10).
area_distance(12, 3, 9).
area_distance(12, 4, 9).
area_distance(12, 5, 8).
area_distance(12, 6, 9).
area_distance(12, 7, 10).
area_distance(12, 8, 10).
area_distance(12, 9, 11).
area_distance(12, 10, 12).
area_distance(12, 11, 12).
area_distance(12, 13, 12).
area_distance(13, 1, 13).
area_distance(13, 2, 6).
area_distance(13, 3, 5).
area_distance(13, 4, 5).
area_distance(13, 5, 4).
area_distance(13, 6, 5).
area_distance(13, 7, 6).
area_distance(13, 8, 6).
area_distance(13, 9, 7).
area_distance(13, 10, 8).
area_distance(13, 11, 8).
area_distance(13, 12, 12).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Could be usefull in next Steps.
%%%% Warehouse Data
%% All Data as they where given by the Port.
warehouse_data(code(('NAG1 1B',1)), name('NAG1 1B'), type('NA'), cap20(0), cap40(15)).
warehouse_data(code(('ODG2',2)), name('ODG2'), type('OD'), cap20(0), cap40(20)).
warehouse_data(code(('PL50',3)), name('PL50'), type('NA'), cap20(0), cap40(23)).
warehouse_data(code(('PL53',4)), name('PL53'), type('OD'), cap20(0), cap40(48)).
warehouse_data(code(('Z3AP',5)), name('Z3AP'), type('ZA'), cap20(3), cap40(0)).
warehouse_data(code(('Z3BP',6)), name('Z3BP'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z13A',7)), name('Z13A'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('Z13B',8)), name('Z13B'), type('KO'), cap20(16), cap40(16)).
warehouse_data(code(('Z13C',9)), name('Z13C'), type('KO'), cap20(21), cap40(21)).
warehouse_data(code(('Z14',10)), name('Z14'), type('KO'), cap20(16), cap40(14)).
warehouse_data(code(('Z16',11)), name('Z16'), type('KO'), cap20(20), cap40(14)).
warehouse_data(code(('Z17A',12)), name('Z17A'), type('ZA'), cap20(3), cap40(3)).
warehouse_data(code(('Z17B',13)), name('Z17B'), type('ZA'), cap20(6), cap40(6)).
warehouse_data(code(('Z19',14)), name('Z19'), type('ZA'), cap20(0), cap40(15)).
warehouse_data(code(('Z20A',15)), name('Z20A'), type('ZA'), cap20(14), cap40(6)).
warehouse_data(code(('Z20B',16)), name('Z20B'), type('ZA'), cap20(10), cap40(5)).
warehouse_data(code(('Z20C',17)), name('Z20C'), type('ZA'), cap20(14), cap40(6)).
warehouse_data(code(('Z21A',18)), name('Z21A'), type('ZA'), cap20(15), cap40(13)).
warehouse_data(code(('Z21B',19)), name('Z21B'), type('ZA'), cap20(15), cap40(7)).
warehouse_data(code(('Z21C',20)), name('Z21C'), type('ZA'), cap20(15), cap40(8)).
warehouse_data(code(('Z21D',21)), name('Z21D'), type('ZA'), cap20(10), cap40(4)).
warehouse_data(code(('Z22A',22)), name('Z22A'), type('ZA'), cap20(19), cap40(9)).
warehouse_data(code(('Z22B',23)), name('Z22B'), type('ZA'), cap20(20), cap40(9)).
warehouse_data(code(('Z22C',24)), name('Z22C'), type('ZA'), cap20(19), cap40(8)).
warehouse_data(code(('Z22D',25)), name('Z22D'), type('ZA'), cap20(9), cap40(6)).
warehouse_data(code(('Z26A',26)), name('Z26A'), type('ZA'), cap20(19), cap40(12)).
warehouse_data(code(('Z26C',27)), name('Z26C'), type('ZA'), cap20(19), cap40(12)).
warehouse_data(code(('Z27A',28)), name('Z27A'), type('ZA'), cap20(11), cap40(12)).
warehouse_data(code(('Z27B',29)), name('Z27B'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z27C',30)), name('Z27C'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z27D',31)), name('Z27D'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z27E',32)), name('Z27E'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z28A',33)), name('Z28A'), type('ZA'), cap20(11), cap40(11)).
warehouse_data(code(('Z28B',34)), name('Z28B'), type('ZA'), cap20(12), cap40(8)).
warehouse_data(code(('Z28C',35)), name('Z28C'), type('ZA'), cap20(37), cap40(33)).
warehouse_data(code(('Z29A',36)), name('Z29A'), type('ZA'), cap20(3), cap40(0)).
warehouse_data(code(('Z29B',37)), name('Z29B'), type('ZA'), cap20(6), cap40(5)).
warehouse_data(code(('Z30A',38)), name('Z30A'), type('ZA'), cap20(11), cap40(11)).
warehouse_data(code(('Z30B',39)), name('Z30B'), type('ZA'), cap20(10), cap40(10)).
warehouse_data(code(('Z30C',40)), name('Z30C'), type('ZA'), cap20(13), cap40(13)).
warehouse_data(code(('Z31A',41)), name('Z31A'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z31B',42)), name('Z31B'), type('ZA'), cap20(10), cap40(10)).
warehouse_data(code(('Z31C',43)), name('Z31C'), type('ZA'), cap20(10), cap40(10)).
warehouse_data(code(('Z32A',44)), name('Z32A'), type('ZA'), cap20(14), cap40(14)).
warehouse_data(code(('Z32B',45)), name('Z32B'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z32C',46)), name('Z32C'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z32D',47)), name('Z32D'), type('ZA'), cap20(11), cap40(11)).
warehouse_data(code(('Z32E',48)), name('Z32E'), type('ZA'), cap20(11), cap40(11)).
warehouse_data(code(('Z33A',49)), name('Z33A'), type('ZA'), cap20(8), cap40(8)).
warehouse_data(code(('Z33B',50)), name('Z33B'), type('ZA'), cap20(8), cap40(8)).
warehouse_data(code(('Z33C',51)), name('Z33C'), type('ZA'), cap20(8), cap40(8)).
warehouse_data(code(('Z33D',52)), name('Z33D'), type('ZA'), cap20(7), cap40(7)).
warehouse_data(code(('Z34A',53)), name('Z34A'), type('ZA'), cap20(11), cap40(11)).
warehouse_data(code(('Z34B',54)), name('Z34B'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z34C',55)), name('Z34C'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z50A',56)), name('Z50A'), type('ZA'), cap20(6), cap40(6)).
warehouse_data(code(('Z50B',57)), name('Z50B'), type('ZA'), cap20(11), cap40(11)).
warehouse_data(code(('Z50C',58)), name('Z50C'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z50D',59)), name('Z50D'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z50E',60)), name('Z50E'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z50F',61)), name('Z50F'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z50G',62)), name('Z50G'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('Z51A',63)), name('Z51A'), type('ZA'), cap20(6), cap40(6)).
warehouse_data(code(('Z51B',64)), name('Z51B'), type('ZA'), cap20(6), cap40(6)).
warehouse_data(code(('Z51C',65)), name('Z51C'), type('ZA'), cap20(6), cap40(6)).
warehouse_data(code(('Z51D',66)), name('Z51D'), type('ZA'), cap20(12), cap40(0)).
warehouse_data(code(('Z51E',67)), name('Z51E'), type('ZA'), cap20(12), cap40(0)).
warehouse_data(code(('Z51F',68)), name('Z51F'), type('ZA'), cap20(12), cap40(0)).
warehouse_data(code(('C6',69)), name('C6'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('C7',70)), name('C7'), type('KO'), cap20(3), cap40(3)).
warehouse_data(code(('C8',71)), name('C8'), type('KO'), cap20(3), cap40(3)).
warehouse_data(code(('C9',72)), name('C9'), type('KO'), cap20(3), cap40(3)).
warehouse_data(code(('C10',73)), name('C10'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('C16',74)), name('C16'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('C17',75)), name('C17'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('C19',76)), name('C19'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('C21',77)), name('C21'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('C22',78)), name('C22'), type('KO'), cap20(6), cap40(6)).
warehouse_data(code(('ZL4A',79)), name('ZL4A'), type('NA'), cap20(15), cap40(15)).
warehouse_data(code(('ZL4B',80)), name('ZL4B'), type('NA'), cap20(8), cap40(8)).
warehouse_data(code(('ZLT1',81)), name('ZLT1'), type('NA'), cap20(15), cap40(15)).
warehouse_data(code(('ZLT2',82)), name('ZLT2'), type('NA'), cap20(16), cap40(16)).
warehouse_data(code(('ZLT3',83)), name('ZLT3'), type('NA'), cap20(18), cap40(18)).
warehouse_data(code(('ZLT6',84)), name('ZLT6'), type('NA'), cap20(0), cap40(24)).
warehouse_data(code(('ZLT7',85)), name('ZLT7'), type('NA'), cap20(24), cap40(24)).
warehouse_data(code(('ZLT8',86)), name('ZLT8'), type('NA'), cap20(38), cap40(38)).
warehouse_data(code(('ZLT9',87)), name('ZLT9'), type('NA'), cap20(18), cap40(18)).
warehouse_data(code(('NPA',88)), name('NPA'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('NPB',89)), name('NPB'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('NPC',90)), name('NPC'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('NPD',91)), name('NPD'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('NPE',92)), name('NPE'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('NPF',93)), name('NPF'), type('KO'), cap20(11), cap40(11)).
warehouse_data(code(('NPG',94)), name('NPG'), type('KO'), cap20(10), cap40(10)).
warehouse_data(code(('ZS2A',95)), name('ZS2A'), type('ZA'), cap20(12), cap40(12)).
warehouse_data(code(('ZS2B',96)), name('ZS2B'), type('ZA'), cap20(28), cap40(28)).
