(* ========== Vaja 8: Moduli  ========== *)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
"Once upon a time, there was a university with a peculiar tenure policy. All
 faculty were tenured, and could only be dismissed for moral turpitude. What
 was peculiar was the definition of moral turpitude: making a false statement
 in class. Needless to say, the university did not teach computer science.
 However, it had a renowned department of mathematics.

 One Semester, there was such a large enrollment in complex variables that two
 sections were scheduled. In one section, Professor Descartes announced that a
 complex number was an ordered pair of reals, and that two complex numbers were
 equal when their corresponding components were equal. He went on to explain
 how to convert reals into complex numbers, what "i" was, how to add, multiply,
 and conjugate complex numbers, and how to find their magnitude.

 In the other section, Professor Bessel announced that a complex number was an
 ordered pair of reals the first of which was nonnegative, and that two complex
 numbers were equal if their first components were equal and either the first
 components were zero or the second components differed by a multiple of 2π. He
 then told an entirely different story about converting reals, "i", addition,
 multiplication, conjugation, and magnitude.

 Then, after their first classes, an unfortunate mistake in the registrar's
 office caused the two sections to be interchanged. Despite this, neither
 Descartes nor Bessel ever committed moral turpitude, even though each was
 judged by the other's definitions. The reason was that they both had an
 intuitive understanding of type. Having defined complex numbers and the
 primitive operations upon them, thereafter they spoke at a level of
 abstraction that encompassed both of their definitions.

 The moral of this fable is that:
   Type structure is a syntactic discipline for enforcing levels of
   abstraction."

 from:
 John C. Reynolds, "Types, Abstraction, and Parametric Polymorphism", IFIP83
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)


(*----------------------------------------------------------------------------*]
 Definirajte signaturo [NAT], ki določa strukturo naravnih števil. Ima osnovni 
 tip, funkcijo enakosti, ničlo in enko, seštevanje, odštevanje in množenje.
 Hkrati naj vsebuje pretvorbe iz in v OCamlov [int] tip.

 Opomba: Funkcije za pretvarjanje ponavadi poimenujemo [to_int] and [of_int],
 tako da skupaj z imenom modula dobimo ime [NAT.of_int], ki nam pove, da 
 pridobivamo naravno število iz celega števila.
[*----------------------------------------------------------------------------*)

module type NAT = sig
  type t

  val eq   : t -> t -> bool
  val zero : t
  val one : t

  val add : t -> t -> t
  val substract : t -> t -> t
  val multiply : t -> t -> t

  val to_int : t -> int
  val of_int : int -> t 
end

(*----------------------------------------------------------------------------*]
 Napišite implementacijo modula [Nat_int], ki zgradi modul s signaturo [NAT],
 kjer kot osnovni tip uporablja OCamlov tip [int].

 Namig: Dokler ne implementirate vseh funkcij v [Nat_int], se bo OCaml pritoževal.
 Temu se lahko izognete tako, da funkcije, ki še niso napisane, nadomestite z 
 [failwith "later"], vendar to ne deluje za konstante.
[*----------------------------------------------------------------------------*)


(* Tu definiramo konkreten modul, ki za osnovo uporablja naš NAT. NAT, ki smo ga definirali zgoraj, je osnova. *)

(* TAKOLE NAPIŠEMO TISTI failwith:
module Nat_int : NAT = struct

  type t = int

  let eq x y = x = y
  let zero = 0
  let one = 1

  let add x y = failwith "later"
  let substract x y = failwith "later"
  let multiply x y = failwith "later"

  let to_int x = x
  let of_int x =  *)

module Nat_int : NAT = struct

  type t = int

  let eq x y = x = y
  let zero = 0
  let one = 1

  let add x y = x + y
  let substract x y = if x - y < 0 then 0 else x - y
  let multiply x y = x * y

  let to_int x = x
  let of_int x = x

end

(* Ko tole  vtipkamo v terminal, bo vrgel ven neko abstraktno definicijo.

# Nat_int.zero;;
- : Nat_int.t = <abstr>

# Nat_int.to_int(Nat_int.zero);;
- : int = 0
*)


(*----------------------------------------------------------------------------*]
 Napišite implementacijo [NAT], ki temelji na Peanovih aksiomih:
 https://en.wikipedia.org/wiki/Peano_axioms
   
 Osnovni tip modula definirajte kot vsotni tip, ki vsebuje konstruktor za ničlo
 in konstruktor za naslednika nekega naravnega števila.
 Večino funkcij lahko implementirate s pomočjo rekurzije. Na primer, enakost
 števil [k] in [l] določimo s hkratno rekurzijo na [k] in [l], kjer je osnoven
 primer [Zero = Zero].

[*----------------------------------------------------------------------------*)

module Nat_peano : NAT = struct

  type t = Z | S of t (*Tu pomeni Z Zero in S Successor*)

  let eq x y = x = y
  let zero = Z
  let one = S Z
  
  let rec add x y =
    match x with
    | Z -> y
    | S x' -> S (add x' y)
  
  let rec multiply x y =
    match y with
    | Z -> Z
    | S y' -> add x (multiply x y')

  let rec substract x y =
    match x, y with
    | _, Z -> x
    | S x, S y -> substract x y
    | Z, _ -> Z 

  let rec to_int x =
    match x with
    | Z -> 0
    | S x' -> 1 + (to_int x')

  let rec of_int x = if x <= 0 then Z else S (of_int (x - 1))

end

(* 3 ~ S(S(S Z)) *)

let three = Nat_peano.of_int 3
let seven = Nat_peano.of_int 7

(*
# Nat_peano.substract seven three;;
- : Nat_peano.t = <abstr>
# Nat_peano.to_int(Nat_peano.substract seven three);; 
- : int = 4
*)


(*----------------------------------------------------------------------------*]
 V OCamlu lahko module podajamo kot argumente funkcij, z uporabo besede
 [module]. Funkcijo, ki sprejme modul, torej definiramo kot

 # let f (module M : M_sig) = ...

 in ji podajamo argumente kot 

 # f (module M_implementation);;

 Funkcija [sum_nat_100] sprejme modul tipa [NAT] in z uporabo modula sešteje
 prvih 100 naravnih števil. Ker funkcija ne more vrniti rezultata tipa [NAT.t]
 (saj ne vemo, kateremu od modulov bo pripadal, torej je lahko [int] ali pa
  variantni tip), na koncu vrnemo rezultat tipa [int] z uporabo metode [to_int].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # sum_nat_100 (module Nat_int);;
 - : int = 4950
 # sum_nat_100 (module Nat_peano);;
 - : int = 4950
[*----------------------------------------------------------------------------*)

(* Zgoraj v testnih primerih so sešteli od 0 do vključno 99, zato pride za 100 manj kot v naši funkciji*)

let sum_nat_100 (module Nat : NAT) =
  let hundred = Nat.of_int 100 in
  let rec sum_x_100 x =
    if Nat.eq x hundred then 
      hundred
    else
      (* V int bi to naredili tako: x + sum_x_100 (x + 1) *)
      Nat.add x (sum_x_100 (Nat.add x Nat.one))
  in
  sum_x_100 Nat.zero |> Nat.to_int


(*
# sum_nat_100 (module Nat_peano);; 
- : int = 5050
# sum_nat_100 (module Nat_int);;    
- : int = 5050
 *)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Now we follow the fable told by John Reynolds in the introduction.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Definirajte signaturo modula kompleksnih števil.
 Potrebujemo osnovni tip, test enakosti, ničlo, enko, imaginarno konstanto i,
 negacijo, konjugacijo, seštevanje in množenje. 
[*----------------------------------------------------------------------------*)

module type COMPLEX = sig
  type t

  val eq : t -> t -> bool

  val zero : t
  val one : t
  val i : t

  val negacija : t -> t
  val konjugacija : t -> t
  val sestevanje : t -> t -> t
  val mnozenje : t -> t -> t
end

(*----------------------------------------------------------------------------*]
 Napišite kartezično implementacijo kompleksnih števil, kjer ima vsako
 kompleksno število realno in imaginarno komponento.
[*----------------------------------------------------------------------------*)

module Cartesian : COMPLEX = struct

  type t = {re : float; im : float}

  let eq x y = x = y

  let zero = {re = 0. ; im = 0.}
  let one = {re = 1. ; im = 0.}
  let i = {re = 0. ; im = 1.}
  
  let negacija x = {re = -. x.re ; im = -. x.im }
  let konjugacija x = {re = x.re ; im = -. x.im }
  let sestevanje x y = {re = x.re +. y.re ; im = x.im +. y.im }
  let mnozenje x y = {re = (x.re *. y.re -. x.im *. y.im) ; im = (x.re *. y.im +. x.im *. y.re)}
  (* Dodajte manjkajoče! *)

end

(*----------------------------------------------------------------------------*]
 Sedaj napišite še polarno implementacijo kompleksnih števil, kjer ima vsako
 kompleksno število radij in kot (angl. magnitude in argument).
   
 Priporočilo: Seštevanje je v polarnih koordinatah zahtevnejše, zato si ga 
 pustite za konec (lahko tudi za konec stoletja).
[*----------------------------------------------------------------------------*)

module Polar : COMPLEX = struct

  type t = {magn : float; arg : float}

  (* Pomožne funkcije za lažje življenje. *)
  let pi = 2. *. acos 0.
  let rad_of_deg deg = (deg /. 180.) *. pi
  let deg_of_rad rad = (rad /. pi) *. 180.

  let eq x y = 
    (x.magn = 0. && y.magn = 0.)
    || (x.magn = y.magn && x.arg = y.arg)

  let zero = {magn = 0.; arg = 0.}
  let one = {magn = 1.; arg = 0.}
  let i = {magn = 1.; arg = pi/.2.}

  let negacija x = {magn = x.magn ; arg = x.arg +. pi}
  let konjugacija x = {magn = x.magn ; arg = -. x.arg}
  let sestevanje x y = failwith "later"
  let mnozenje x y = failwith "later"
end

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 SLOVARJI
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Na vajah z iskalnimi drevesi smo definirali tip slovarjev 
 [('key, 'value) dict], ki je implementiral [dict_get], [dict_insert] in
 [print_dict]. Napišite primerno signaturo za slovarje [DICT] in naredite
 implementacijo modula z drevesi (kot na prejšnjih vajah). 
 
 Modul naj vsebuje prazen slovar [empty] in pa funkcije [get], [insert] in
 [print] (print naj ponovno deluje zgolj na [(string, int) t].
[*----------------------------------------------------------------------------*)

module type DICT = sig
  type ('key, 'value ) t
  val empty : ('key, 'value ) t
  val get : 'key -> ('key, 'value ) t -> 'value option
  val insert : 'key -> 'value -> ('key, 'value ) t -> ('key, 'value ) t
  val print : (string, int) t -> unit
end

module Tree_dict : DICT = struct

  type ('key, 'value ) t =
    | Node of (('key, 'value) t) * 'key * 'value * (('key, 'value) t)
	  | Empty
  
  let empty = Empty
  
  let leaf key value = Node (Empty, key, value, Empty)

  let rec get key = function
	  | Empty -> None
	  | Node (lt, k, v, rt) when key < k -> get key lt
	  | Node (lt, k, v, rt) when key > k -> get key rt
	  | Node (lt, k, v, rt) (* k= key*) -> Some v

  let rec print drevo =
	  match drevo with
	  | Empty -> ()
	  | Node (lt, k, v, rt) -> (
		  print lt;
		  print_string (k ^ " : "); 
		  print_int v;
  		print_newline ();
	  	print rt)

  let rec insert key value dict =  
  	match dict with
	    | Empty -> leaf key value
    	| Node (lt, k, v, rt) when key < k -> Node(insert key value lt, k, v, rt)
	    | Node (lt, k, v, rt) when k < key -> Node (lt, k, v, insert key value rt)
	    | Node (lt, k, v, rt) (* k = key *)-> Node (lt, key, value, rt)
end

(*----------------------------------------------------------------------------*]
 Funkcija [count (module Dict) list] prešteje in izpiše pojavitve posameznih
 elementov v seznamu [list] s pomočjo izbranega modula slovarjev.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # count (module Tree_dict) ["b"; "a"; "n"; "a"; "n"; "a"];;
 a : 3
 b : 1
 n : 2
 - : unit = ()
[*----------------------------------------------------------------------------*)
;;
(*Tu na konec damo ;; da s ene sesuje zaradi tele spodnje funkcije, ko želimo preverjati rešitve*)

let count (module Dict : DICT) list =
  let koliko kljuc drevo = (Dict.get kljuc drevo) in
    (* Funkcija koliko sprejme ključ in vrne vrednost, ki je option. *)
  let rec drevo_iz_seznama seznam acc_drevo =
    match seznam with
    | [] -> acc_drevo
    | x :: xs -> 
      match koliko x acc_drevo with
      | None -> drevo_iz_seznama xs (Dict.insert x 1 acc_drevo)
      | Some stevilo -> drevo_iz_seznama xs (Dict.insert x (stevilo + 1) acc_drevo) 
  in
  Dict.print (drevo_iz_seznama list Dict.empty)
    