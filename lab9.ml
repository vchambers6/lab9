(*
                              CS51 Lab 9
                         Substitution Semantics

Objective:

This lab practices concepts of substitution semantics. 

 *)

(*
                               SOLUTION
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

(* ANSWER: The expression evaluates to 36:

    # let x = 3 + 5 in
        (fun x -> x * x) (x - 2)  ;;
    - : int = 36

*)

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
to the definition in Figure 13.3, on page 139? We've numbered the 
equations in the order they appear in that figure. Note, the existance
of both evaluation rules, such as R_int and R_+ and substitution rules. 
Figure 13.3 includes only substitution rules and rules for evaluating
free variables. 

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

(* ANSWER:

    8 - 2 =>
           | 8 => 8         (R_int)
           | 2 => 2         (R_int)
           => 6             (R_-)
 *)

(*....................................................................
Exercise 5. Carry out the derivation for the semantics of the
expression 6 * 6.
....................................................................*)

(* ANSWER:

    6 * 6 =>
          | 6 => 6          (R_int)
          | 6 => 6          (R_int)
          => 36             (R_*)

(*....................................................................
Exercise 6. What is the result of the following substitution according
to the definition in Figure 13.3?  

    (x * x) [x |-> 6]
....................................................................*)

(* ANSWER:

    (x * x) [x |-> 6]
        = x [x |-> 6] * x [x |-> 6]     (by Eq. 4)
        = 6 * 6                         (by Eq. 2 twice)
 *)

(*....................................................................
Exercise 7. The set of 10 equations defining substitution in Figure 13.3
is missing an equation for function application. You'll need this
equation in some exercises below. What should such an equation look
like? (Below, we'll refer to this as Eq. 11.)
....................................................................*)

(*    (P R)[x |-> Q] = P[x |-> Q]  R[x |-> Q]       

  Consider the expression below to understand wby Q must be 
  substituted for x in both P and R

  let x = 5 in
  (fun y -> x + y) x
  
  Also note that pre-existing rules for substitution in functions
  govern the semantics of P[x |-> Q]. 
*)

(*....................................................................
Exercise 8. What is the result of the following substitution according
to the definition in Figure 13.3?

    ((fun x -> x * x) (x - 2)) [x |-> 8]
....................................................................*)

(* ANSWER:

    ((fun x -> x * x) (x - 2)) [x |-> 8]
        = ((fun x -> x * x) [x |-> 8]) ((x - 2) [x |-> 8])    (by Eq. 11)
        = (fun x -> x * x) (x [x |-> 8] - 2 [x |-> 8])        (by Eq. 4)
        = (fun x -> x * x) (8 - 2)                            (by Eq. 1)
 *)

(*....................................................................
Exercise 9. Carry out the derivation for the semantics of the
expression

    (fun x -> x * x) (8 - 2)
....................................................................*)

(* ANSWER:

    (fun x -> x * x) (8 - 2) =>         
         | fun x -> x + x => fun x -> x + x    (R_fun)
         | 8 - 2 => 6                          (Exercise 4)
         | 6 * 6 => 36                         (Exercises 6 and 5)
         => 36                                 (R_app)
 *)

(*....................................................................
Exercise 10. Finally, carry out the derivation for the semantics of the
expression

    let x = 3 + 5 in (fun x -> x * x) (x - 2)
....................................................................*)

(* ANSWER:

    let x = 3 + 5 in (fun x -> x * x) (x - 2) =>
         | 3 + 5 => 8                              (Exercise 1)
         | (fun x -> x * x) (8 - 2) => 36          (Exercise 8)
         => 36                                     (R_let)
 *)

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

(* ANSWER:

1. let x = 3 in let y = x in f x y

FV(let x = 3 in let y = x in f x y)
= (FV(let y = x in f x y) - {x}) U FV(3)
= (FV(f x y) - {y}) U FV(x)) - {x}
= ({f, x, y} - {y}) U {x}) - {x}
= ({f, x} U {x}) - {x}
= {f, x} - {x}
= {f}

2. let x = x in let y = x in f x y

FV(let x = x in let y = x in f x y)
= (FV(let y = x in f x y) - {x}) U FV(x)
= (FV(f x y) - {y}) U FV(x)) - {x} U {x}
= (({f, x, y} - {y}) U {x}) - {x}) U {x}
= (({f, x} U {x}) - {x}) U {x}
= ({f, x} - {x}) U {x}
= {f, x}

3. let x = y in let y = x in f x y

FV(let x = y in let y = x in f x y)
= (FV(let y = x in f x y) - {x}) U FV(y)
= (FV(f x y) - {y}) U FV(x)) - {x} U {y}
= (({f, x, y} - {y}) U {x}) - {x}) U {y}
= (({f, x} U {x}) - {x}) U {y}
= ({f, x} - {x}) U {y}
= {f, y}

4. let x = fun y -> x in x

FV(let x = fun y -> x in x)
= (FV(x) - {x}) U FV(fun y -> x)
= ({x} - {x}) U (FV(x) - {y})
= {} U {x}
= {x}

*)

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

(* ANSWER: 

1. (x + 1)[x |-> 50]
      = x[x |-> 50] + 1[x |-> 50]       (by Eq. 4)
      = 50 + 1[x |-> 50]                (by Eq. 2)
      = 50 + 1                          (by Eq. 1)

   If you came up with the answer 51, you're confusing the
   substitution operation, which operates purely syntactically to
   replace portions of an expression, with evaluation, which
   simplifies an expression to one that is semantically equivalent but
   can be syntactically quite different.

   In case you were wondering where the parentheses around (x + 1)
   went, they disappear because those were really just in the concrete
   syntax to notate the abstract syntax, which is what the
   substitution operation operates on.

2. (x + 1)[x |-> 50] 
      = x[y |-> 50] + 1[y |-> 50] 
      = x + 1

3. (x * x)[x |-> 2] 
      = x[x |-> 2] * x[x |-> 2]
      = 2 * 2

4. (let x = y * y in x + x)[x |-> 3] 
      = let x = (y * y)[x |-> 3] in (x + x)            (by Eq. 8)
      = let x = y[x |-> 3] * y[x |-> 3] in
        x + x                                          (by Eq. 4 )
      = let x = y * y in x + x                         (by Eq. 3 twice)

5. (let x = y * y in x + x)[y |-> 3]
      = let x = (y * y)[y |-> 3] in (x + x)[y |-> 3]   (by Eq. 8)
      = let x = y[y |-> 3] * y[y |-> 3] in
        x[y |-> 3] + x[y |-> 3]                        (by Eq. 4 twice)
      = let x = 3 * 3 in x[y |-> 3] + x[y |-> 3]       (by Eq. 2 twice)
      = let x = 3 * 3 in x + x                         (by Eq. 3 twice)
 *)

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

(* ANSWER:

1. 2 * 25 =>
          | 2 => 2              (R_int)
          | 5 => 5              (R_int)
          => 50                 (R_* )

2. let x = 2 * 25 in x + 1 =>
                           | 2 * 25 => 50       (from Exercise 3.1)
                           | 50 + 1 =>
                                    | 50 => 50  (R_int)
                                    | 1 => 1    (R_int)
                                    => 51       (R_+)
                           => 51                (R_let)

(The 50 + 1 is the result of (x + 1)[x |-> 50], as per Exercise 12.1.)

3. let x = 2 in x * x =>
                      |  2 => 2
                      |  2 * 2 =>
                               | 2 => 2
                               | 2 => 2
                               | 2 * 2 => 4
                      => 4

(The 2 * 2 is the result of (x * x)[x |-> 2], as per Exercise 1.3.)

4. let x = 51 in let x = 124 in x =>
                                  |  51 => 51
                                  |  let x = 124 in x =>
                                                      |  124 => 124
                                                      |  124 => 124
                                                      => 124
                                  => 124
 *)

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
  | Minus 
  | Times
  | Divide ;;

type unop = 
  | Negate ;;

type expr =
  | Int of int
  | Var of varspec
  | Binop of binop * expr * expr
  | Unop of unop * expr
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

module VarSet = Set.Make (struct
                            type t = varspec
                            let compare = String.compare
                          end) ;;

let rec free_vars (exp : expr) : VarSet.t =
  match exp with
  | Var x -> VarSet.singleton x
  | Int _ -> VarSet.empty
  | Unop(_, arg) -> free_vars arg
  | Binop(_, arg1, arg2) ->
     VarSet.union (free_vars arg1) (free_vars arg2)
  | Let(x, def, body) -> 
     VarSet.union (free_vars def) (VarSet.remove x (free_vars body))
;;

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
  let rec sub (exp : expr) : expr =
    match exp with
    | Var x ->
       if x = var_name then repl else exp
    | Int _ -> exp
    | Unop(op, arg) -> Unop(op, sub arg)
    | Binop(op, arg1, arg2) -> Binop(op, sub arg1, sub arg2)
    | Let(x, def, body) ->
       if x = var_name then Let(x, sub def, body)
       else Let(x, sub def, sub body)
  in
  sub exp ;;
(*......................................................................
Exercise 17: Complete the eval function below. Try to implement these
functions from scratch. If you get stuck, however, a good (though
incomplete) start can be found in section 13.4.2 of the textbook.
......................................................................*)

(* Please use the provided exceptions as appropriate. *)
exception UnboundVariable of string ;;
exception IllFormed of string ;;

let binopeval (op : binop) (v1 : expr) (v2 : expr) : expr =
  match op, v1, v2 with
  | Plus, Int x1, Int x2 -> Int (x1 + x2)
  | Plus, _, _ -> raise (IllFormed "can't add non-integers")
  | Minus, Int x1, Int x2 -> Int (x1 - x2)
  | Minus, _, _ -> raise (IllFormed "can't subtract non-integers")
  | Times, Int x1, Int x2 -> Int (x1 * x2) 
  | Times, _, _ -> raise (IllFormed "can't multiply non-integers")
  | Divide, Int x1, Int x2 -> Int (x1 / x2)
  | Divide, _, _ -> raise (IllFormed "can't divide non-integers") ;;

let unopeval (op : unop) (e : expr) : expr = 
  match op, e with 
  | Negate, Int x -> Int (~- x)
  | Negate, _ -> raise (IllFormed "can't negate non-integers")

let rec eval (e : expr) : expr =
  match e with
  | Int _ -> e
  | Var x -> raise (UnboundVariable x)
  | Unop (op, e1) -> unopeval op (eval e1)
  | Binop (op, e1, e2) -> binopeval op (eval e1) (eval e2)
  | Let (x, def, body) -> eval (subst body x (eval def)) ;;

(*......................................................................
Go ahead and test eval by evaluating some arithmetic expressions and 
let bindings.

For instance, try the following: 

# eval (Let ("x", Int 6, 
                  Let ("y", Int 3, 
                            Binop (Times, Var "x", Var "y")))) ;;
- : expr = Int 18
......................................................................*)
