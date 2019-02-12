#!/usr/bin/env swipl

:- use_module(library(clpfd)).

:- style_check(-singleton).
:- style_check(-no_effect).
:- style_check(-var_branches).
:- style_check(-discontiguous).
:- style_check(-charset).

collatz_is(X,N) :-
    (
    Temp2 #= 2 * N,
    X = Temp2
    );
    (
    Temp9 #= 2 * K,
    Temp8 #= Temp9 + 1,
    X = Temp8 ->
    Temp18 #= 3 * X,
    Temp17 #= Temp18 + 1,
    N = Temp17
    ).

