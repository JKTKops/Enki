#!/usr/bin/env swipl

:- use_module(library(clpfd)).

:- style_check(-singleton).
:- style_check(-no_effect).
:- style_check(-var_branches).
:- style_check(-discontiguous).
:- style_check(-charset).

:- initialization(main, main).

main(Args) :-
    fib_seq_up_to(4000000,Temp6),
    even_in(Temp6,Temp4),
    sum(Temp4,Temp2),
    writeln(Temp2).



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

fib_seq(A,B,Limit,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    A #> Limit -> 
    AUTOGENERATEDFUNCTIONRESULT = empty
    );
    (
    Temp18 #= A + B,
    fib_seq(B,Temp18,Limit,Temp14),
    AUTOGENERATEDFUNCTIONRESULT = cons(A,Temp14)
    ).

fib_seq_up_to(N,Temp0) :-
    fib_seq(0,1,N,Temp0).

divides(A,B) :-
    Temp2 #= A * N,
    B = Temp2.

even_in(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
    List = cons(H,T),
    divides(2,H) -> 
    even_in(T,Temp21),
    AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp21)
    );
    (
    List = cons(H,T) -> 
    even_in(T,Temp39),
    AUTOGENERATEDFUNCTIONRESULT = Temp39
    );
    (
    AUTOGENERATEDFUNCTIONRESULT = empty
    ).


