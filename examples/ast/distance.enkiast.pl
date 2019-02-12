#!/usr/bin/env swipl

:- use_module(library(clpfd)).

:- style_check(-singleton).
:- style_check(-no_effect).
:- style_check(-var_branches).
:- style_check(-discontiguous).
:- style_check(-charset).

distance_from_to(X1,Y1,X2,Y2,Temp0) :-
    Temp2 #= X1 - X2,
    Temp1 #= Temp2 ^ 2,
    Temp9 #= Y1 - Y2,
    Temp8 #= Temp9 ^ 2,
    Temp0 #= Temp1 + Temp8.

