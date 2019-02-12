#!/usr/bin/env swipl

:- use_module(library(clpfd)).

:- style_check(-singleton).
:- style_check(-no_effect).
:- style_check(-var_branches).
:- style_check(-discontiguous).
:- style_check(-charset).

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

odd(X) :-
    Temp3 #= 2 * K,
    Temp2 #= Temp3 + 1,
    X = Temp2.

even(X) :-
    Temp2 #= 2 * K,
    X = Temp2.

collatz(X,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    odd(X) -> 
    Temp7 #= 3 * X,
    Temp6 #= Temp7 + 1,
    AUTOGENERATEDFUNCTIONRESULT = Temp6
    );
    (
    Temp15 #= 2 * N,
    X = Temp15,
    AUTOGENERATEDFUNCTIONRESULT = N
    ).

collatz_sequence_of(X,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    X = 1 -> 
    AUTOGENERATEDFUNCTIONRESULT = cons(X,empty)
    );
    (
    collatz(X,Temp20),
    collatz_sequence_of(Temp20,Temp18),
    AUTOGENERATEDFUNCTIONRESULT = cons(X,Temp18)
    ).


