(* 1. naloga *)
(*a*)

let odstej_trojici (x1, x2, x3) (y1, y2, y3) = (x1-y1, x2-y2, x3-y3)

(*b*)

let max_retultat_do_n f n =
	let rec pomozna f n acc =
		if n <= 0 then acc else
			(if f n < acc then pomozna f (n-1) acc else pomozna f (n-1) (f n))  
	in pomozna f n (f 0)

let a = (fun x -> 3*x)

(*c*)
let pocisti_seznam opt_sez =
	let rec pomozna sez acc =
		match sez with
		| [] -> acc
		| None :: xs -> pomozna xs acc
		| Some x :: xs -> pomozna xs (x::acc)
	in pomozna opt_sez []

(*d*)
let rec preveri_urejenost sez =
	let rec narasca sez =
		match sez with
		| [] -> true
		| x :: [] -> true
		| x1 :: x2 :: xs -> if x1 < x2 then narasca (x2 :: xs) else false
  in
  (sez |> List.filter (fun x -> x mod 2 == 0) |> narasca)
  && (sez |> List.filter (fun x -> x mod 2 == 1) |> List.rev |> narasca)

(*val filter : ('a -> bool) -> 'a list -> 'a list
filter p l returns all the elements of the list l that satisfy 
the predicate p. The order of the elements in the input list is 
preserved.*)

(* 2. naloga *)

type 'a gnezdenje =
	| Element of 'a
	| Podseznam of 'a gnezdenje list

(* a *)

let gnezdenje_primer = [ Element 1; Element 2; 
		Podseznam [Element 3; Podseznam [Element 4]; Podseznam []];
		Podseznam [ Element 5]
		]

let primer_enostaven =  [Element 1; Element 2; Podseznam [Element 3]]

(* b *)

let najvecja_globina sez_g =
	let rec pomozna sez acc =
		match sez with
		(* Pazi: sez je gnezden seznam!! *)
		| [] -> acc
		| x :: xs ->
			match x with
			| Element a -> pomozna xs acc
			| Podseznam b -> max (pomozna b (acc + 1)) (pomozna xs acc)
	in pomozna sez_g 1

(* c *)

let preslikaj f sez =
	let rec pomozna f sez acc =
		match sez with
		| [] -> List.rev acc
		| x :: xs ->
			match x with
			| Element a -> pomozna f xs ((Element (f a)) :: acc)
			| Podseznam b -> pomozna f xs ((Podseznam (pomozna f b [])) :: acc)
	in pomozna f sez []

(*preslikaj (fun x -> x*3) primer_enostaven;;*)

(* d *)
let splosci sez_g =
	let rec pomozna sez_g acc =
		match sez_g with
		| [] -> List.rev acc
		| x :: xs ->
			match x with
			| Element a -> pomozna xs (a :: acc)
			| Podseznam b -> pomozna xs ((pomozna b []) @ acc)
	in pomozna sez_g []

(* e *)

let alternirajoci_konstruktorji sez_g =
	let rec pomozna sez_g acc =
		(* Akumulator bo imel vrednost 0 na začetku, 1, če je bil zadnji
		element Element, in 2, če je bil zadnji element Podseznam. *)
		match sez_g with
		| [] -> true
		| x :: xs -> 
			match x with
			| Element a -> if acc = 1 then false else pomozna xs 1
			| Podseznam b -> if acc = 2 then false else pomozna xs 2
	in pomozna sez_g 0

(* f *)
(*
# List.fold_left (-) 0 [1;2;3];;   (* ((0 - 1) - 2) - 3 *)
- : int = -6
*)
let zlozi_preko_gnezdenja f acc gnezdenje =
	  (* Napišemo lastno repno rekurzivno funkcijo za združevanje. *)
  let zdruzi xs ys =
    let rec prelozi ys = function
      | [] -> ys
      | x :: xs -> prelozi (x :: ys) xs
    in
    prelozi ys (List.rev xs)
  in
  let rec zlozi f acc = function
    | [] -> acc
    | Element x :: xs -> zlozi f (f acc x) xs
    | Podseznam podsez :: xs -> zlozi f acc (zdruzi podsez xs)
  in
  zlozi f acc gnezdenje