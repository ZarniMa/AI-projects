/*
    In this HW08, I am doing my family genelogy for my experet system.
    There are 20 facts and 12 rules.

    Example queries:

    dad(zar_zone, Who).
    - this query tells me who is zar_zone's father.

    mom(zar_zone, Who).
    -this query tells me who is zar_zone's father.

    brother(win_myint, Who).
    -this query tells me who is win_myint's brother.

    sister(than_aye, Who).
    -this query tells me who is than_aye's sister.

    my_uncle_dad_side(zar_zone, Who).
    -this query tells me who is my uncle from my father side.

    my_uncle_mom_side(zar_zone, Who).
    -this query tells me who is my uncle from my mother side.

    my_aunt_dad_side(zar_zone, Who).
    -this query tells me who is my aunt from my father side.

    my_aunt_mom_side(zar_zone, Who).
    -this query tells me who is my aunt from my mother side.

    my_uncle_dadside_wife(zar_zone, Who).
    -this query tells me who married my uncle from my father side.

    my_uncle_momside_wife(zar_zone, Who).
    -this query tells me who married my uncle from my mother side.

    my_aunt_momside_husband(zar_zone, Who).
    -this query tells me who married my aunt from my mother side.

    my_mom(zar_zone, Who).
    -this query tells me who is my mother.

    my_dad(zar_zone, Who).
    -this query tells me whi is my father. 

*/


/*
    The following are facts about my family genelogy.
*/

% zar_zone is me, and win_myint is my father.
dad(zar_zone, win_myint).

% than_aye is my mother.
mom(zar_zone, than_aye).

% my father(win_myint) has one brother.
brother(win_myint, win_sein).

% my mother(than_aye) have five brothers.
brother(than_aye, hla_aung).
brother(than_aye, aung_myint).
brother(than_aye, hla_win).
brother(than_aye, win_m).
brother(than_aye, thein_win).

% my mother(than_aye) have two sisters.
sister(than_aye, ngoot_fong).
sister(than_aye, ne_than).

% my father(win_myint) doesn't have sister.
% i made this fact as my aunt name NULL, so I can make a rule
% to check my aunt from my father side.
sister(win_myint, null).

% my father's brother married with baby_soe
married(win_sein, baby_soe).

% my mother siblings are also married, expcet one(thein_win).
married(hla_aung, san_nwe).
married(aung_myint, khin_aye).
married(hla_win, hla_hla ).
married(win_m, win_win).
married(ngoot_fong, khai_ming).
married(ne_than, kyaw_lin).

/* this fact says, my father married with my mom
    and my mom married with my father if my father married with my mother. */
married(win_myint, than_aye).
married(than_aye,win_myint) :- married(win_myint, than_aye).

/*
    the following are rules.
*/

% it checks X's brother Y, and Y married with Z.
is_myuncle_married(X,Z) :-
    brother(X,Y), married(Y,Z).

% it checks X's sister Y, and Y amrried with Z.
is_myaunt_married(X,Z) :-
    sister(X,Y), married(Y,Z).

% it checks X's father is Y, and Y is Z brother.
my_uncle_dad_side(X,Z) :-
    dad(X,Y), brother(Y,Z).

% it checks X's father is Y, and Y is Z sister.
my_aunt_dad_side(X,Z) :-
    dad(X,Y), sister(Y,Z).

% it checks X's mother is Y, and Y is Z brother.
my_uncle_mom_side(X,Z) :-
    mom(X,Y), brother(Y,Z).

% it checks X's mother is Y, and Y is Z sister.
my_aunt_mom_side(X,Z) :-
    mom(X,Y), sister(Y,Z).

% it checks X's father is Y, and Y's brother married with Z.
my_uncle_dadside_wife(X,Z) :-
    dad(X,Y), is_myuncle_married(Y,Z).

% it checks X's father is Y, and Y's sister married with Z.
my_aunt_dadside_husband(X,Z) :-
    dad(X,Y), is_myaunt_married(Y,Z).

% it checks X's mother is Y, and Y's brother married with Z.
my_uncle_momside_wife(X,Z) :-
    mom(X,Y), is_myuncle_married(Y,Z).

% it checks X's mother is Y, and Y's sister married with Z.
my_aunt_momside_husband(X,Z) :-
    mom(X,Y), is_myaunt_married(Y,Z).

% it checks X's father is Y, and Y married with Z.
my_mom(X,Z) :-
    dad(X,Y), married(Y,Z).

% it checks X's mother is Y, and Y married with Z.
my_dad(X,Z) :-
    mom(X,Y), married(Y,Z).


