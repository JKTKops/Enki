#!/usr/bin/env swipl

:- use_module(library(clpfd)).

:- use_module(library(yall)).

:- style_check(-singleton).
:- style_check(-no_effect).
:- style_check(-var_branches).
:- style_check(-discontiguous).
:- style_check(-charset).


map_built_in(F,empty(), empty()).
map_built_in(F,cons(H,T),cons(NewH,NewT)) :-
    call(F, H, NewH),
    map_built_in(F, T, NewT).

filter_built_in(F, empty(), empty()).
filter_built_in(F, cons(H, T), Out) :-
    call(F, H) ->
        filter_built_in(F, T, Temp),
        Out = cons(H, Temp);
    filter_built_in(F, T, Out).

call_built_in(F, X, Res) :- call(F, X, Res).



:- initialization(main, main).

main(Argv) :-
    test({}/[_2,_2Result]>>(_2Result = ({_2}/[_3]>>({_2,_3}/[Temp124]>>(const(_2,_3,Temp124))))),24,Temp123),
    display(Temp123),
    test({}/[_4,_4Result]>>(_4Result = ({_4}/[_5]>>({_4,_5}/[Temp128]>>(add(_4,_5,Temp128))))),1,Temp127),
    as_text(Temp127,Temp126),
    display(Temp126),
    range_to(1,20,Temp133),
    map_over({X}/[_6]>>({X,_6}/[Temp132]>>(add(4,_6,Temp132))),Temp133,Temp131),
    as_text(Temp131,Temp130),
    display(Temp130).
% EnkiString
display(X) :-
    writeln(X).

% FuncType (Any "T3") EnkiString
as_text(X,Temp1) :-
    term_to_atom(X,Temp1).

% FuncType (FuncType (Any "T9") (Any "T10")) (FuncType (TypeName [Named "list",Any "T9"]) (TypeName [Named "list",Any "T10"]))
map_over(F,Xs,Temp2) :-
    map_built_in(F,Xs,Temp2).

% FuncType (TypeName [Named "list",Any "T16"]) (FuncType (Any "T16") (TypeName [Named "list",Any "T16"]))
filter_with(Xs,F,Temp3) :-
    filter_built_in(F,Xs,Temp3).

% FuncType (FuncType (Any "T22") (Any "T23")) (FuncType (Any "T22") (Any "T23"))
call_on(F,X,Temp4) :-
    call_built_in(F,X,Temp4).

% FuncType (Any "T26") (Any "T26")
the(X,X).

% FuncType (Any "T28") (Any "T28")
id(X,X).

% EnkiInt
odd(X) :-
    Temp5 #= (2 * K),
    Temp6 #= (Temp5 + 1),
    X = Temp6.

% EnkiInt
even(X) :-
    Temp7 #= (2 * K),
    X = Temp7.

% FuncType EnkiInt EnkiInt
square_root(X,Root) :-
    Temp8 #= (Root ^ 2),
    Temp8 = X.

% RuleType EnkiInt EnkiInt
divides(A,B) :-
    Temp9 #= (A * N),
    B = Temp9.

% FuncType (Any "T49") (FuncType (TypeName [Named "list",Any "T49"]) (TypeName [Named "list",Any "T49"]))
prepend_to(Head,Tail,cons(Head,Tail)).

% FuncType (TypeName [Named "list",Any "T66"]) EnkiInt
length_of(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            length_of(T,Temp11),
            Temp12 #= (1 + Temp11),
            AUTOGENERATEDFUNCTIONRESULT = Temp12
        ;
            AUTOGENERATEDFUNCTIONRESULT = 0
    ).

% FuncType (Any "T79") (FuncType (TypeName [Named "list",Any "T79"]) (TypeName [Named "list",Any "T79"]))
construct(Head,Full,Tail) :-
    Full = cons(Head,Tail).

% FuncType (TypeName [Named "list",Any "T106"]) (FuncType (TypeName [Named "list",Any "T98"]) (TypeName [Named "list",Any "T98"]))
concat_with(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A = cons(H,T)
            ->
            concat_with(T,B,Temp13),
            prepend_to(H,Temp13,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
            AUTOGENERATEDFUNCTIONRESULT = B
    ).

% FuncType (TypeName [Named "list",TypeName [Named "list",Any "T136"]]) (TypeName [Named "list",Any "T129"])
flatten(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            flatten(T,Temp14),
            concat_with(H,Temp14,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
            AUTOGENERATEDFUNCTIONRESULT = empty()
    ).

% FuncType (TypeName [Named "list",Any "T167"]) (FuncType (TypeName [Named "list",Any "T167"]) (TypeName [Named "list",Any "T167"]))
reverseAcc(A,Acc,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A = cons(H,T)
            ->
            reverseAcc(T,cons(H,Acc),AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
            AUTOGENERATEDFUNCTIONRESULT = Acc
    ).

% FuncType (TypeName [Named "list",Any "T176"]) (TypeName [Named "list",Any "T176"])
reverse_list(A,Temp16) :-
    reverseAcc(A,empty(),Temp16).

% FuncType (TypeName [Named "list",EnkiInt]) EnkiInt
sum_of(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            sum_of(T,Temp18),
            Temp19 #= (H + Temp18),
            AUTOGENERATEDFUNCTIONRESULT = Temp19
        ;
            AUTOGENERATEDFUNCTIONRESULT = 0
    ).

% FuncType EnkiInt (FuncType (TypeName [Named "list",EnkiInt]) (TypeName [Named "list",EnkiInt]))
multiples_of_in(A,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T),
            divides(A,H)
            ->
            multiples_of_in(A,T,Temp21),
            AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp21)
        ;
        (
                List = cons(H,T)
                ->
                multiples_of_in(A,T,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = empty()
        )
    ).

% FuncType (TypeName [Named "list",Any "T283"]) EnkiString
formatHelper(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,empty())
            ->
            as_text(H,Temp23),
            atom_concat(Temp23,"]",AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
        (
                List = cons(H,T)
                ->
                as_text(H,Temp25),
                atom_concat(Temp25,",",Temp24),
                formatHelper(T,Temp26),
                atom_concat(Temp24,Temp26,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = "]"
        )
    ).

% FuncType (TypeName [Named "list",Any "T298"]) EnkiString
format_list(List,Temp27) :-
    formatHelper(List,Temp28),
    atom_concat("[",Temp28,Temp27).

% FuncType EnkiInt (FuncType EnkiInt (TypeName [Named "list",EnkiInt]))
range_to(Low,High,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Low #> High
            ->
            AUTOGENERATEDFUNCTIONRESULT = empty()
        ;
            Temp30 #= (Low + 1),
            range_to(Temp30,High,Temp29),
            AUTOGENERATEDFUNCTIONRESULT = cons(Low,Temp29)
    ).

% FuncType EnkiInt (FuncType EnkiInt (TypeName [Named "list",EnkiInt]))
range_from_to(Low,High,Temp31) :-
    range_to(Low,High,Temp31).

% FuncType EnkiInt (FuncType EnkiInt (TypeName [Named "list",EnkiInt]))
integers_from_to(Low,High,Temp32) :-
    range_to(Low,High,Temp32).

% FuncType (TypeName [Named "list",EnkiInt]) (TypeName [Named "list",EnkiInt])
inc(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            Temp33 #= (H + 1),
            inc(T,Temp34),
            AUTOGENERATEDFUNCTIONRESULT = cons(Temp33,Temp34)
        ;
            AUTOGENERATEDFUNCTIONRESULT = empty()
    ).

% FuncType (TypeName [Named "list",Any "T405"]) (FuncType (TypeName [Named "list",Any "T406"]) (TypeName [Named "list",TypeName [Named "pair",Any "T389",Any "T390"]]))
zip_and(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A = cons(HA,TA),
            B = cons(HB,TB)
            ->
            zip_and(TA,TB,Temp36),
            AUTOGENERATEDFUNCTIONRESULT = cons(pair_and(HA,HB),Temp36)
        ;
            AUTOGENERATEDFUNCTIONRESULT = empty()
    ).

% FuncType EnkiInt (FuncType EnkiInt EnkiInt)
max_of_and(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A #> B
            ->
            AUTOGENERATEDFUNCTIONRESULT = A
        ;
            AUTOGENERATEDFUNCTIONRESULT = B
    ).

% FuncType EnkiInt (FuncType EnkiInt EnkiInt)
min_of_and(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A #> B
            ->
            AUTOGENERATEDFUNCTIONRESULT = A
        ;
            AUTOGENERATEDFUNCTIONRESULT = B
    ).

% FuncType (TypeName [Named "list",EnkiInt]) EnkiInt
maximum_of(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,empty())
            ->
            AUTOGENERATEDFUNCTIONRESULT = H
        ;
        (
                List = cons(H,T)
                ->
                maximum_of(T,Temp38),
                max_of_and(H,Temp38,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = 0
        )
    ).

% FuncType (TypeName [Named "list",EnkiInt]) EnkiInt
minimum_of(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,empty())
            ->
            AUTOGENERATEDFUNCTIONRESULT = H
        ;
        (
                List = cons(H,T)
                ->
                minimum_of(T,Temp40),
                min_of_and(H,Temp40,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = 0
        )
    ).

% FuncType EnkiInt (FuncType EnkiInt EnkiInt)
find_factor_of_starting_with(N,X,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            divides(X,N)
            ->
            AUTOGENERATEDFUNCTIONRESULT = X
        ;
            Temp42 #= (X + 1),
            find_factor_of_starting_with(N,Temp42,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
    ).

% FuncType EnkiInt (TypeName [Named "list",EnkiInt])
factors_of(N,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            N = 1
            ->
            AUTOGENERATEDFUNCTIONRESULT = empty()
        ;
            find_factor_of_starting_with(N,2,Factor),
            Factor = Factor,
            Temp44 #= (N div Factor),
            factors_of(Temp44,Temp43),
            AUTOGENERATEDFUNCTIONRESULT = cons(Factor,Temp43)
    ).

% FuncType EnkiInt (TypeName [Named "list",EnkiInt])
digits_of(N,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            N #< 10
            ->
            AUTOGENERATEDFUNCTIONRESULT = cons(N,empty())
        ;
            Temp46 #= (10 * Rest),
            Temp47 #= (Temp46 + Digit),
            N = Temp47,
            Digit #>= 0,
            Digit #< 10,
            digits_of(Rest,Temp48),
            AUTOGENERATEDFUNCTIONRESULT = cons(Digit,Temp48)
    ).

% TypeName [Named "list",Any "T592"]
palindrome(List) :-
    reverse_list(List,List),
    List = List.

% EnkiInt
palindromic_number(N) :-
    digits_of(N,Temp50),
    palindrome(Temp50).

% FuncType (Any "T627") (FuncType (TypeName [Named "list",Any "T628"]) (TypeName [Named "list",TypeName [Named "pair",Any "T611",Any "T612"]]))
pair_with_each(X,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            pair_with_each(X,T,Temp52),
            AUTOGENERATEDFUNCTIONRESULT = cons(pair_and(X,H),Temp52)
        ;
            AUTOGENERATEDFUNCTIONRESULT = empty()
    ).

% FuncType (TypeName [Named "list",Any "T674"]) (FuncType (TypeName [Named "list",Any "T675"]) (TypeName [Named "list",Any "T652"]))
cartesian_product_of_and(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A = cons(H,T)
            ->
            pair_with_each(H,B,Temp53),
            cartesian_product_of_and(T,B,Temp54),
            concat_with(Temp53,Temp54,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
            AUTOGENERATEDFUNCTIONRESULT = empty()
    ).

% FuncType (TypeName [Named "list",Any "T687"]) (FuncType (TypeName [Named "list",Any "T688"]) (TypeName [Named "list",Any "T689"]))
pairs_of_and(A,B,Temp55) :-
    cartesian_product_of_and(A,B,Temp55).

% FuncType EnkiInt (FuncType (TypeName [Named "list",Any "T716"]) (TypeName [Named "list",Any "T707"]))
take_from(N,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            N #> 0,
            List = cons(H,T)
            ->
            Temp57 #= (N - 1),
            take_from(Temp57,T,Temp56),
            AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp56)
        ;
            AUTOGENERATEDFUNCTIONRESULT = empty()
    ).

% FuncType EnkiInt (FuncType (TypeName [Named "list",Any "T742"]) (TypeName [Named "list",Any "T742"]))
drop_from(N,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            N #> 0,
            List = cons(H,T)
            ->
            Temp58 #= (N - 1),
            drop_from(Temp58,T,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
            AUTOGENERATEDFUNCTIONRESULT = List
    ).

% FuncType (TypeName [Named "list",EnkiInt]) EnkiInt
product_of(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            product_of(T,Temp59),
            Temp60 #= (H * Temp59),
            AUTOGENERATEDFUNCTIONRESULT = Temp60
        ;
            AUTOGENERATEDFUNCTIONRESULT = 1
    ).

% FuncType EnkiInt (FuncType (TypeName [Named "list",Any "T792"]) (FuncType (Any "T800") (Any "T800")))
element_of_starting_with(N,List,H,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            N #=< 0
            ->
            AUTOGENERATEDFUNCTIONRESULT = H
        ;
        (
                List = cons(X,Rest)
                ->
                Temp61 #= (N - 1),
                element_of_starting_with(Temp61,Rest,X,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = H
        )
    ).

% FuncType EnkiInt (FuncType (TypeName [Named "list",Any "T847"]) (TypeName [Named "list",TypeName [Named "list",Any "T820"]]))
chunks_of_size_in(L,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = empty()
            ->
            AUTOGENERATEDFUNCTIONRESULT = empty()
        ;
            take_from(L,List,Temp62),
            drop_from(L,List,Temp64),
            chunks_of_size_in(L,Temp64,Temp63),
            AUTOGENERATEDFUNCTIONRESULT = cons(Temp62,Temp63)
    ).

% FuncType EnkiInt (FuncType (TypeName [Named "list",Any "T854"]) (TypeName [Named "list",TypeName [Named "list",Any "T855"]]))
chunks_of_length_in(L,List,Temp65) :-
    chunks_of_size_in(L,List,Temp65).

% RuleType (TypeName [Named "list",Any "T868"]) (Any "T868")
contains(List,Element) :-
    (
            List = cons(H,T),
            H = Element
            ->
            1 = 1
        ;
        (
                List = cons(H,T)
                ->
                contains(T,Element)
            ;
                1 = 2
        )
    ).

% FuncType (Any "T902") (FuncType (TypeName [Named "list",Any "T902"]) (TypeName [Named "list",Any "T902"]))
remove_from(Element,List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T),
            H = Element
            ->
            AUTOGENERATEDFUNCTIONRESULT = T
        ;
        (
                List = cons(H,T)
                ->
                remove_from(Element,T,Temp67),
                AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp67)
            ;
                1 = 2,
                AUTOGENERATEDFUNCTIONRESULT = empty()
        )
    ).

% FuncType (Any "T916") (FuncType (Any "T917") (TypeName [Named "mapping",Any "T916",Any "T917"]))
maps_to(X,Y,pipe_dash_gt_(X,Y)).

% FuncType EnkiInt (FuncType EnkiInt (TypeName [Named "ordering"]))
compare_to(A,B,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            A #> B
            ->
            AUTOGENERATEDFUNCTIONRESULT = greater()
        ;
        (
                A #< B
                ->
                AUTOGENERATEDFUNCTIONRESULT = less()
            ;
                AUTOGENERATEDFUNCTIONRESULT = equal()
        )
    ).

% FuncType (TypeName [Named "mapping",Any "T939",Any "T940"]) (Any "T939")
key_in(AUTOGENARG3,K) :-
    maps_to(K,V,AUTOGENARG3),
    AUTOGENARG3 = AUTOGENARG3.

% FuncType (TypeName [Named "mapping",Any "T950",Any "T951"]) (Any "T951")
value_in(AUTOGENARG3,V) :-
    maps_to(K,V,AUTOGENARG3),
    AUTOGENARG3 = AUTOGENARG3.

% FuncType (TypeName [Named "mapping",EnkiInt,Any "T963"]) (FuncType (TypeName [Named "mapping",EnkiInt,Any "T972"]) (TypeName [Named "ordering"]))
compare_keys_to(AUTOGENARG3,AUTOGENARG5,Temp69) :-
    AUTOGENARG3 = pipe_dash_gt_(K1,V1),
    AUTOGENARG5 = pipe_dash_gt_(K2,V2),
    compare_to(K1,K2,Temp69).

% FuncType (TypeName [Named "mapping",Any "T985",EnkiInt]) (FuncType (TypeName [Named "mapping",Any "T994",EnkiInt]) (TypeName [Named "ordering"]))
compare_values_to(AUTOGENARG3,AUTOGENARG5,Temp70) :-
    AUTOGENARG3 = pipe_dash_gt_(K1,V1),
    AUTOGENARG5 = pipe_dash_gt_(K2,V2),
    compare_to(V1,V2,Temp70).

% FuncType (Any "T1014") (FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1014",Any "T1015"]]) (Any "T1015"))
get_key_from(Key,Map,V) :-
    contains(Map,pipe_dash_gt_(Key,V)).

% FuncType (Any "T1031") (FuncType (Any "T1032") (FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1031",Any "T1032"]]) (TypeName [Named "list",TypeName [Named "mapping",Any "T1031",Any "T1032"]])))
insert_into(K,V,Map,cons(pipe_dash_gt_(K,V),Map)).

% FuncType (Any "T1048") (FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1048",Any "T1049"]]) (TypeName [Named "list",TypeName [Named "mapping",Any "T1048",Any "T1049"]]))
remove_key_from(Key,Map,Temp75) :-
    remove_from(pipe_dash_gt_(Key,V),Map,Temp75).

% FuncType (Any "T1083") (FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1083",EnkiInt]]) (TypeName [Named "list",TypeName [Named "mapping",Any "T1083",EnkiInt]]))
increment_key_in(Key,Map,Temp77) :-
    Temp80 #= (V + 1),
    remove_from(pipe_dash_gt_(Key,V),Map,Temp78),
    insert_into(Key,Temp80,Temp78,Temp77).

% FuncType (TypeName [Named "mapping",EnkiInt,Any "T1126"]) (FuncType (TypeName [Named "list",TypeName [Named "mapping",EnkiInt,Any "T1127"]]) (TypeName [Named "mapping",EnkiInt,Any "T1126"]))
max_key_at_least_in(M1,Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M2,Assocs),
            compare_keys_to(M2,M1,Temp81),
            Temp81 = less()
            ->
            max_key_at_least_in(M2,Assocs,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
        (
                Map = cons(P,Assocs)
                ->
                max_key_at_least_in(M1,Assocs,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = M1
        )
    ).

% FuncType (TypeName [Named "list",TypeName [Named "mapping",EnkiInt,Any "T1156"]]) (TypeName [Named "maybe",TypeName [Named "mapping",EnkiInt,Any "T1156"]])
max_key_in(Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M1,Assocs)
            ->
            max_key_at_least_in(M1,Map,Temp83),
            AUTOGENERATEDFUNCTIONRESULT = just(Temp83)
        ;
            AUTOGENERATEDFUNCTIONRESULT = nothing()
    ).

% FuncType (TypeName [Named "mapping",EnkiInt,Any "T1201"]) (FuncType (TypeName [Named "list",TypeName [Named "mapping",EnkiInt,Any "T1202"]]) (TypeName [Named "mapping",EnkiInt,Any "T1201"]))
min_key_no_more_than_in(M1,Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M2,Assocs),
            compare_keys_to(M2,M1,Temp84),
            Temp84 = less()
            ->
            min_key_no_more_than_in(M2,Assocs,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
        (
                Map = cons(P,Assocs)
                ->
                min_key_no_more_than_in(M1,Assocs,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = M1
        )
    ).

% FuncType (TypeName [Named "list",TypeName [Named "mapping",EnkiInt,Any "T1231"]]) (TypeName [Named "maybe",TypeName [Named "mapping",EnkiInt,Any "T1231"]])
min_key_in(Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M1,Assocs)
            ->
            min_key_no_more_than_in(M1,Map,Temp86),
            AUTOGENERATEDFUNCTIONRESULT = just(Temp86)
        ;
            AUTOGENERATEDFUNCTIONRESULT = nothing()
    ).

% FuncType (TypeName [Named "mapping",Any "T1276",EnkiInt]) (FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1277",EnkiInt]]) (TypeName [Named "mapping",Any "T1276",EnkiInt]))
max_value_at_least_in(M1,Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M2,Assocs),
            compare_values_to(M2,M1,Temp87),
            Temp87 = less()
            ->
            max_value_at_least_in(M2,Assocs,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
        (
                Map = cons(P,Assocs)
                ->
                max_value_at_least_in(M1,Assocs,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = M1
        )
    ).

% FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1306",EnkiInt]]) (TypeName [Named "maybe",TypeName [Named "mapping",Any "T1306",EnkiInt]])
max_value_in(Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M1,Assocs)
            ->
            max_value_at_least_in(M1,Map,Temp89),
            AUTOGENERATEDFUNCTIONRESULT = just(Temp89)
        ;
            AUTOGENERATEDFUNCTIONRESULT = nothing()
    ).

% FuncType (TypeName [Named "mapping",Any "T1351",EnkiInt]) (FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1352",EnkiInt]]) (TypeName [Named "mapping",Any "T1351",EnkiInt]))
min_value_no_more_than_in(M1,Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M2,Assocs),
            compare_values_to(M2,M1,Temp90),
            Temp90 = less()
            ->
            min_value_no_more_than_in(M2,Assocs,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
        (
                Map = cons(P,Assocs)
                ->
                min_value_no_more_than_in(M1,Assocs,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = M1
        )
    ).

% FuncType (TypeName [Named "list",TypeName [Named "mapping",Any "T1381",EnkiInt]]) (TypeName [Named "maybe",TypeName [Named "mapping",Any "T1381",EnkiInt]])
min_value_in(Map,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            Map = cons(M1,Assocs)
            ->
            min_value_no_more_than_in(M1,Map,Temp92),
            AUTOGENERATEDFUNCTIONRESULT = just(Temp92)
        ;
            AUTOGENERATEDFUNCTIONRESULT = nothing()
    ).

% FuncType (Any "T1391") (TypeName [Named "list",Any "T1391"])
singleton(X,cons(X,empty())).

% FuncType (TypeName [Named "list",Any "T1428"]) (TypeName [Named "list",Any "T1410"])
init(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,empty())
            ->
            AUTOGENERATEDFUNCTIONRESULT = empty()
        ;
        (
                List = cons(H,T)
                ->
                init(T,Temp96),
                AUTOGENERATEDFUNCTIONRESULT = cons(H,Temp96)
            ;
                AUTOGENERATEDFUNCTIONRESULT = empty()
        )
    ).

% FuncType (TypeName [Named "list",Any "T1464"]) (TypeName [Named "maybe",Any "T1464"])
last(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,empty())
            ->
            AUTOGENERATEDFUNCTIONRESULT = just(H)
        ;
        (
                List = cons(H,T)
                ->
                last(T,AUTOGENERATEDFUNCTIONRESULT),
                AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
            ;
                AUTOGENERATEDFUNCTIONRESULT = nothing()
        )
    ).

% RuleType (TypeName [Named "list",Any "T1483"]) (Any "T1483")
does_not_contain(List,Element) :-
    (
            List = cons(Element,T)
            ->
            1 = 2
        ;
        (
                List = cons(H,T),
                H \= Element
                ->
                does_not_contain(T,Element)
            ;
                1 = 1
        )
    ).

% FuncType EnkiString (TypeName [Named "pair",EnkiInt,EnkiString])
digit_from(Str,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            atom_concat("0",Rest,Str),
            Str = Str
            ->
            AUTOGENERATEDFUNCTIONRESULT = pair_and(0,Rest)
        ;
        (
                atom_concat("1",Rest,Str),
                Str = Str
                ->
                AUTOGENERATEDFUNCTIONRESULT = pair_and(1,Rest)
            ;
            (
                    atom_concat("2",Rest,Str),
                    Str = Str
                    ->
                    AUTOGENERATEDFUNCTIONRESULT = pair_and(2,Rest)
                ;
                (
                        atom_concat("3",Rest,Str),
                        Str = Str
                        ->
                        AUTOGENERATEDFUNCTIONRESULT = pair_and(3,Rest)
                    ;
                    (
                            atom_concat("4",Rest,Str),
                            Str = Str
                            ->
                            AUTOGENERATEDFUNCTIONRESULT = pair_and(4,Rest)
                        ;
                        (
                                atom_concat("5",Rest,Str),
                                Str = Str
                                ->
                                AUTOGENERATEDFUNCTIONRESULT = pair_and(5,Rest)
                            ;
                            (
                                    atom_concat("6",Rest,Str),
                                    Str = Str
                                    ->
                                    AUTOGENERATEDFUNCTIONRESULT = pair_and(6,Rest)
                                ;
                                (
                                        atom_concat("7",Rest,Str),
                                        Str = Str
                                        ->
                                        AUTOGENERATEDFUNCTIONRESULT = pair_and(7,Rest)
                                    ;
                                    (
                                            atom_concat("8",Rest,Str),
                                            Str = Str
                                            ->
                                            AUTOGENERATEDFUNCTIONRESULT = pair_and(8,Rest)
                                        ;
                                        (
                                                atom_concat("9",Rest,Str),
                                                Str = Str
                                                ->
                                                AUTOGENERATEDFUNCTIONRESULT = pair_and(9,Rest)
                                            ;
                                                AUTOGENERATEDFUNCTIONRESULT = pair_and(-1,Rest)
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    ).

% FuncType EnkiString (TypeName [Named "list",EnkiInt])
digits_from(Str,AUTOGENERATEDFUNCTIONRESULT) :-
    digit_from(Str,Temp100),
    pair_and(D,Rest) = Temp100,
    (
            D = -1
            ->
            AUTOGENERATEDFUNCTIONRESULT = empty()
        ;
            digits_from(Rest,Temp101),
            prepend_to(D,Temp101,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
    ).

% FuncType EnkiInt (FuncType EnkiInt EnkiInt)
mod(A,B,R) :-
    Temp102 #= (Q * B),
    Temp103 #= (Temp102 + R),
    A = Temp103,
    0 #=< R,
    R #< B.

% FuncType EnkiInt (TypeName [Named "list",EnkiInt])
to_reversed_digits(X,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            X #< 10
            ->
            singleton(X,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
        ;
            mod(X,10,Temp104),
            Temp106 #= (X div 10),
            to_reversed_digits(Temp106,Temp105),
            prepend_to(Temp104,Temp105,AUTOGENERATEDFUNCTIONRESULT),
            AUTOGENERATEDFUNCTIONRESULT = AUTOGENERATEDFUNCTIONRESULT
    ).

% FuncType EnkiInt (TypeName [Named "list",EnkiInt])
to_digits(X,Temp107) :-
    to_reversed_digits(X,Temp108),
    reverse_list(Temp108,Temp107).

% FuncType (TypeName [Named "list",EnkiInt]) EnkiInt
from_reversed_digit_list(List,AUTOGENERATEDFUNCTIONRESULT) :-
    (
            List = cons(H,T)
            ->
            from_reversed_digit_list(T,Temp109),
            Temp110 #= (10 * Temp109),
            Temp111 #= (Temp110 + H),
            AUTOGENERATEDFUNCTIONRESULT = Temp111
        ;
            AUTOGENERATEDFUNCTIONRESULT = 0
    ).

% FuncType (TypeName [Named "list",EnkiInt]) EnkiInt
from_digit_list(List,Temp112) :-
    reverse_list(List,Temp113),
    from_reversed_digit_list(Temp113,Temp112).

% FuncType EnkiString EnkiInt
int_from(Str,Temp114) :-
    digits_from(Str,Temp115),
    from_digit_list(Temp115,Temp114).

% FuncType (FuncType (Any "T1739") (FuncType (Any "T1739") (Any "T1740"))) (FuncType (Any "T1739") (Any "T1740"))
test(F,X,Temp116) :-
    call_on(F,X,Temp117),
    call_on(Temp117,X,Temp116).

% FuncType (Any "T1753") (Any "T1753")
identity(X,X).

% FuncType (Any "T1760") (Any "T1772")
secondTest(X,Temp118) :-
    call_on({X}/[_0]>>({X,_0}/[Temp119]>>(test(_0,X,Temp119))),{}/[_1]>>({_1}/[Temp120]>>(identity(_1,Temp120))),Temp118).

% FuncType EnkiInt (FuncType EnkiInt EnkiInt)
add(X,Y,Temp121) :-
    Temp121 #= (X + Y).

% FuncType (Any "T1782") (FuncType (Any "T1783") (Any "T1782"))
const(X,Y,X).