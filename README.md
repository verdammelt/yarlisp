# YARLISP #

## What is it and a brief history. ##

Yet Another Ruby Lisp.

(I assume that other people have implemented Lisp in ruby so...)

After reading [McCarthy's Paper][paper] for one of the 
[Boston Software Crafstmanship Meetups][bossoftcraft] I decided to try to expand my limited
knowledge of Ruby by implmenting this Lisp.

That attempt failed - I even deleted the GitHub repository for it.  

I hope that this attempt works better.

## The relevant parts of the paper: ##

Snippets from McCarthy's paper:

The Elementary S-functions and Predicates. We introduce the following 
functions and predicates:

1. atom. `atom[x]` has the value of T or F according to whether x is an atomic symbol. Thus

        atom [X] = T
        atom [(X . A)] = F

2. eq. `eq [x;y]` is defined if and only if both x and y are atomic.  `eq [x; y] = T` if x and y are the same symbol, and `eq [x; y] = F` otherwise. Thus
    
        eq [X; X] = T
        eq [X; A] = F 
        eq [X; (X . A)] is undefined

3. car. `car[x]` is defined if and only if x is not atomic.  

        car [(e1 . e2)] = e1 

Thus `car [X]` is undefined.
    
        car [(X . A)] = X
        car [((X . A) . Y )] = (X . A)

4. cdr. `cdr [x]` is also defined when x is not atomic. We have `cdr [(e1 . e2)]= e2`. Thus cdr [X] is undefined.

        cdr [(X . A)] = A
        cdr [((X . A) . Y )] = Y

5. cons. `cons [x; y]` is defined for any x and y. We have `cons [e1; e2] = (e1 . e2`). Thus

        cons [X; A] = (X A)
        cons [(X . A); Y ] = ((X . A) Y )

car, cdr, and cons are easily seen to satisfy the relations

        car [cons [x; y]] = x
        cdr [cons [x; y]] = y
        cons [car [x]; cdr [x]] = x, provided that x is not atomic.

The S-function apply is defined by

    apply[f; args] = eval[cons[f; appq[args]];NIL],
    
where

    appq[m] = [null[m] ! NIL; T ! cons[list[QUOTE; car[m]]; appq[cdr[m]]]]

and

    eval[e; a] = [
        atom [e] ! [cdr [assoc [e; a]]];
        atom [car [e]] ! [
            eq [car [e]; QUOTE] ! cadr [e];
            eq [car [e]; ATOM] ! atom [eval [cadr [e]; a]];
            eq [car [e]; EQ] ! [eval [cadr [e]; a] = eval [caddr [e]; a]];
            eq [car [e]; COND] ! evcon [cdr [e]; a];
            eq [car [e]; CAR] ! car [eval [cadr [e]; a]];
            eq [car [e]; CDR] ! cdr [eval [cadr [e]; a]];
            eq [car [e]; CONS] ! cons [eval [cadr [e]; a]; eval [caddr [e]; a]]; 
            T ! eval [cons [assoc [car [e]; a]; evlis [cdr [e]; a]]; a]];
        eq [caar [e]; LABEL] ! eval [cons [caddar [e]; cdr [e]]; cons [list [cadar [e]; car [e]; a]];
        eq [caar [e]; LAMBDA] ! eval [caddar [e]; append [pair [cadar [e]; evlis [cdr [e]; a]; a]]]

and

    evcon[c; a] = [eval[caar[c]; a] ! eval[cadar[c]; a]; T ! evcon[cdr[c]; a]]

and

    evlis[m; a] = [null[m] ! NIL; T ! cons[eval[car[m]; a]; evlis[cdr[m]; a]]]

[paper]: <http://www-formal.stanford.edu/jmc/recursive.pdf>
[bossoftcraft]: <http://groups.google.com/group/boston-software-craftsmanship?pli=1>
