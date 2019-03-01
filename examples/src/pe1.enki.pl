#!/usr/bin/env swipl

:- use_module(library(clpfd)).

:- style_check(-singleton).
:- style_check(-no_effect).
:- style_check(-var_branches).
:- style_check(-discontiguous).
:- style_check(-charset).

:- initialization(main, main).

main(Args) :-
    answer_less_than(999,Temp2),
    writeln(Temp2).



odd(X) :-
    Temp3 #= 2 * K,
    Temp2 #= Temp3 + 1,
    X = Temp2.

even(X) :-
    Temp2 #= 2 * K,
    X = Temp2.

square_root(X,Root) :-
    Temp1 #= Root ^ 2,
    Temp1 = X.

divides(A,B) :-
    Temp2 #= A * N,
    B = Temp2.

length_of(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    List = cons(H,T) -> 
    length_of(T,Temp13),
    Temp11 #= 1 + Temp13,
    AUTOGENERATEDFUNCTIONRESULT = Temp11
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = 0
    ).

construct(Head,Full,Tail) :-
    Full = cons(Head,Tail).

concat(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    A = cons(H,T) -> 
    concat(T,B,Temp15),
    AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp15)
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = B
    ).

reverseAcc(A,Acc,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    A = cons(H,T) -> 
    reverseAcc(T,cons(H,Acc),Temp11),
    AUTOGENERATEDFUNCTIONRESULT = Temp11
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = Acc
    ).

reverse_list(A,Temp0) :-
    reverseAcc(A,empty,Temp0).

sum(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    List = cons(H,T) -> 
    sum(T,Temp13),
    Temp11 #= H + Temp13,
    AUTOGENERATEDFUNCTIONRESULT = Temp11
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = 0
    ).

sums_to(List,N) :-
    sum(List,Temp2),
    N = Temp2.

multiples_of_in(A,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    List = cons(H,T),
    divides(A,H) -> 
    multiples_of_in(A,T,Temp21),
    AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp21)
    );
    (
    List = cons(H,T) -> 
    multiples_of_in(A,T,Temp41),
    AUTOGENERATEDFUNCTIONRESULT = Temp41
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = empty
    ).

formatHelper(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    List = cons(H,empty) -> 
    atom_concat(H,"]",Temp11),
    AUTOGENERATEDFUNCTIONRESULT = Temp11
    );
    (
    List = cons(H,T) -> 
    atom_concat(H,",",Temp27),
    formatHelper(T,Temp31),
    atom_concat(Temp27,Temp31,Temp26),
    AUTOGENERATEDFUNCTIONRESULT = Temp26
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = "]"
    ).

format_list(List,Temp0) :-
    formatHelper(List,Temp2),
    atom_concat("[",Temp2,Temp0).

range_to(Low,High,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    Low #> High -> 
    AUTOGENERATEDFUNCTIONRESULT = empty
    );
    (
    Temp16 #= Low + 1,
    range_to(Temp16,High,Temp14),
    AUTOGENERATEDFUNCTIONRESULT = cons(Low,Temp14)
    ).

range_from_to(Low,High,Temp0) :-
    range_to(Low,High,Temp0).

inc(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    List = cons(H,T) -> 
    Temp13 = H + 1,
    inc(T,Temp18),
    AUTOGENERATEDFUNCTIONRESULT = cons(Temp13,Temp18)
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = empty
    ).

zip_and(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    A = cons(HA,TA),
    B = cons(HB,TB) -> 
    zip_and(TA,TB,Temp30),
    AUTOGENERATEDFUNCTIONRESULT = cons(pair_and(HA,HB),Temp30)
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = empty
    ).

answer_less_than(N,Temp45) :-
    range_to(1,N,Temp6),
    multiples_of_in(3,Temp6,Temp2),
    ThreeMult = Temp2,
    range_to(1,N,Temp21),
    multiples_of_in(5,Temp21,Temp17),
    FiveMult = Temp17,
    range_to(1,N,Temp36),
    multiples_of_in(15,Temp36,Temp32),
    FifteenMult = Temp32,
    sum(ThreeMult,Temp47),
    sum(FiveMult,Temp52),
    Temp46 #= Temp47 + Temp52,
    sum(FifteenMult,Temp58),
    Temp45 #= Temp46 - Temp58.


