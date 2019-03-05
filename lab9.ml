(*
                              CS51 Lab 9
                         Substitution Semantics

Objective:

This lab practices concepts of substitution semantics. 

 *)


(*====================================================================
Part 1: Substitution semantics derivation

In this part, you'll work out the formal derivation of the
substitution semantics for the expression

    let x = 3 + 5 in
    (fun x -> x * x) (x - 2)

according to the semantic rules presented in Chapter 13.

Before beginning, what should this expression evaluate to? Test out
your prediction in the OCaml REPL. *)

(* The exercises will take you through the derivation stepwise, so
that you can use the results from earlier exercises in the later
exercises.

By way of example, we do the first couple of exercises for you to give
you the idea.

......................................................................
Exercise 1. Carry out the derivation for the semantics of the
expression 3 + 5.
....................................................................*)

(* ANSWER:

    3 + 5 =>
          | 3 => 3          (R_int)
          | 5 => 5          (R_int)
          => 8              (R_+)

(This derivation was actually given in the reading in Section
13.1. We've annotated each line with the semantic rule that it
uses. You should do that too below.) *)

(*....................................................................
Exercise 2. What is the result of the following substitution according
to the definition in Figure 13.3?

    (x + 5) [x |-> 3]
....................................................................*)

(* ANSWER: Carrying out each step in the derivation:

    (x + 5) [x |-> 3]
        = x [x |-> 3] + 5 [x |-> 3]    (by Eq. 4)
        = 3 + 5 [x |-> 3]              (by Eq. 2)
        = 3 + 5                        (by Eq. 1)

   Again, we've labeled each line with the number of the equation that
   was used from the set of equations for substitution in Figure
   13.3. You should do that too. *)

(*....................................................................
Exercise 3. Carry out the derivation for the semantics of the
expression let x = 3 in x + 5. 
....................................................................*)

(* ANSWER:

    let x = 3 in x + 5 =>
          | 3 => 3          (R_int)
          | 3 + 5 => 8      (Exercises 2 and 1)
          => 8              (R_let)

   Note the labeling of one of the steps with the prior results from
   previous exercises. *)

(* Now it's your turn. We recommend doing these exercises with
pencil on paper, rather than typing them in.

......................................................................
Exercise 4. Carry out the derivation for the semantics of the
expression 8 - 2.
....................................................................*)

(*....................................................................
Exercise 5. Carry out the derivation for the semantics of the
expression 6 * 6.
....................................................................*)

(*....................................................................
Exercise 6. What is the result of the following substitution according
to the definition in Figure 13.3?  

    (x * x) [x |-> 6]
....................................................................*)

(*....................................................................
Exercise 7. The set of 10 equations defining substitution in Figure 13.3
is missing an equation for function application. You'll need this
equation in some exercises below. What should such an equation look
like? (Below, we'll refer to this as Eq. 11.)
....................................................................*)

(*    (P R)[x |-> Q] = ????    *)
(*....................................................................
Exercise 8. What is the result of the following substitution according
to the definition in Figure 13.3?

    ((fun x -> x * x) (x - 2)) [x |-> 8]
....................................................................*)

(*....................................................................
Exercise 9. Carry out the derivation for the semantics of the
expression

    (fun x -> x * x) (8 - 2)
....................................................................*)

(*....................................................................
Exercise 10. Finally, carry out the derivation for the semantics of the
expression

    let x = 3 + 5 in (fun x -> x * x) (x - 2)
....................................................................*)

(*====================================================================
Part 2: Pen and paper exercises with the free variables and
substitution definitions 

In this part, you'll get more practice using the definitions of FV and
substitution from the textbook (Figure 13.3). Feel free to jump ahead
to later problems if you "get it" and are finding the exercises
tedious. *)

(*....................................................................
Exercise 11: Use the definition of FV to derive the set of free
variables in the expressions below. Show all steps using pen and
paper.

1. let x = 3 in let y = x in f x y

2. let x = x in let y = x in f x y

3. let x = y in let y = x in f x y

4. let x = fun y -> x in x
....................................................................*)


(*....................................................................
Exercise 12: What expressions are specified by the following
substitutions? Show all the steps as per the definition of
substitution given in the textbook, Figure 13.3.

1. (x + 1)[x |-> 50] 

2. (x + 1)[y |-> 50]

3. (x * x)[x |-> 2]

4. (let x = y * y in x + x)[x |-> 3]

5. (let x = y * y in x + x)[y |-> 3]

....................................................................*)

(*......................................................................
Exercise 13: For each of the following expressions, derive its final
value using the evaluation rules in the textbook. Show all steps using
pen and paper, and label them with the name of the evaluation rule
used. Where an expression makes use of the evaluation of an earlier
expression, you don't need to rederive the earlier expression's value;
just use it directly.

1. 2 * 25

2. let x = 2 * 25 in x + 1

3. let x = 2 in x * x 

4. let x = 51 in let x = 124 in x 

......................................................................*)

(*====================================================================
Part 3: Implementing a simple arithmetic language.

You will now implement a simple language for evaluating let bindings
and arithmetic expressions. Recall the following abstract syntax for
such a language from the textbook.

<binop> ::= + | - | * | /
<var> ::= x | y | z | ...
<expr> ::= <integer>
        |  <var>
        |  <expr1> <binop> <expr>
        |  <var> = <expr_def> in <expr_body> 

......................................................................
Exercise 14: Augment the provided type definitions to allow for other 
binary operations (at least Minus and Times) and for unary operations 
(at least Negate). Hint: Don't forget to extend the type definition
of expr to support unary operations as well.
....................................................................*)

type varspec = string ;;

type binop =
  | Plus 
  | Divide ;;

type unop = 
  | NotYetImplemented ;;

type expr =
  | Int of int
  | Var of varspec
  | Binop of binop * expr * expr
  | Let of varspec * expr * expr ;;

(*....................................................................
Exercise 15: Write a function free_vars : expr -> varspec Set.t that
returns a set of varspecs corresponding to the free variables in the
expression.

The free variable rules in this simple language are a subset of those
found in Figure 13.3, but we encourage you to first try to determine
the rules on your own, consulting the textbook only as
necessary.

You'll need to use the Set module for this exercise to complete the
definition of the VarSet module by using the Set.Make functor. More
documentation on the Set module can be found at:
https://caml.inria.fr/pub/docs/manual-ocaml/libref/Set.html

You should get behavior such as this, in calculating the free
variables in the expression

    let x = x + y in z * 3      :

    # VarSet.elements 
        (free_vars (Let ("x", 
                         Binop (Plus, Var "x", Var "y"),
                         Binop (Times, Var "z", Int 3)))) ;;
    - : Lab9_soln.VarSet.elt list = ["x"; "y"; "z"]
....................................................................*)

module VarSet = struct end ;;

let free_vars (exp : expr) =
  failwith "free_vars not implemented"

(*......................................................................
Exercise 16: Write a function subst : expr -> varspec -> expr -> expr
that performs substitution, that is, subst p x q returns the
expression that is the result of substituting q for the variable x in
the expression p.

The necessary substitution rules for this simple language are as
follows:

m[x |-> P] = m                           (where m is some integer value)

x[x |-> P] = P

y[x |-> P] = y

(Q + R)[x |-> P] = Q[x |-> P] + R[x |-> P]
                                    (and similarly for other binary ops)

(let x = Q in R)[x |-> P] = let x = Q[x |-> P] in R

(let y = Q in R)[x |-> P] = let y = Q[x |-> P] in R[x |-> P]
                                              (where x does not equal y)

You should get the following behavior:

    # let example = Let ("x", Binop (Plus, Var "x", Var "y"),
                            Binop (Times, Var "z", Var "x")) ;;  
    val example : Lab9_soln.expr =
      Let ("x", Binop (Plus, Var "x", Var "y"), Binop (Times, Var "z", Var "x"))
    # subst example "x" (Int 42) ;;
    - : Lab9_soln.expr =
    Let ("x", Binop (Plus, Int 42, Var "y"), Binop (Times, Var "z", Var "x"))
    # subst example "y" (Int 42) ;;
    - : Lab9_soln.expr =
    Let ("x", Binop (Plus, Var "x", Int 42), Binop (Times, Var "z", Var "x"))
......................................................................*)

let subst (exp : expr) (var_name : varspec) (repl : expr) : expr =
  failwith "subst not implemented" ;;

(*......................................................................
Exercise 17: Complete the eval function below. Try to implement these
functions from scratch. If you get stuck, however, a good (though
incomplete) start can be found in section 13.4.2 of the textbook.
......................................................................*)

(* Please use the provided exceptions as appropriate. *)
exception UnboundVariable of string ;;
exception IllFormed of string ;;

let eval (e : expr) : expr =
  failwith "eval not implemented"

(*......................................................................
Go ahead and test eval by evaluating some arithmetic expressions and 
let bindings.

For instance, try the following: 

# eval (Let ("x", Int 6, 
                  Let ("y", Int 3, 
                            Binop (Times, Var "x", Var "y")))) ;;
- : expr = Int 18
......................................................................*)
