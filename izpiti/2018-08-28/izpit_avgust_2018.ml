(* Prva naloga je vedno oCaml, če je v py, je to 3.naloga, ponavadi piše, da lahko rešuješ v Py.*)
(* Modulov ne pišemo *)
(* Pazi na to, če imaš v tipih int ali float (zaradi operacij) !!!! *)

(* 1. NALOGA *)

(*a*)
let razlika_kvadratov x y = (x + y) * (x + y) - (x * x + y * y)

(*b*)
let uporabi_na_paru f (x, y) = (f x, f y)

(*c*)
let rec ponovi_seznam n sez =
	if n <= 0 then [] else sez @ ponovi_seznam (n-1) sez

let rec ponovi_seznam_tlrec n sez =
	let rec ponovi acc n =
		if n <= 0 then acc else ponovi (acc @ sez) (n-1)
	in 
	ponovi [] n

(*d*)
let rec razdeli sez =
	let rec deli n_acc p_acc = function
	| [] -> ( List.rev n_acc, List.rev p_acc)
	| x :: xs ->
			if x < 0 then
				deli (x :: n_acc) p_acc xs
			else 
				deli n_acc (x :: p_acc) xs
	in
	deli [] [] sez

(* 3. NALOGA *)

type 'a veriga = 
	| Filter of ('a -> bool) * 'a list * 'a veriga
	| Ostalo of 'a list


(*a*)
(* 
Pazi: ($) x y = x $ y
Torej:  (<) 0 = fun x -> 0 < x
				(-) 1 = fun x -> 1 - x
*)

let test = Filter( (>) 0, [], Filter( (>) 10, [], Ostalo [] ))


(*b*)

let rec vstavi n veriga =
	match veriga with
	| Filter (f, sez, ver) -> if f n = true then Filter (f, n :: sez, ver)
														else Filter (f, sez, vstavi n ver)
	| Ostalo (sez) -> Ostalo (n :: sez) 

(* Profesorjeva rešitev: *)
let rec vstavi' x = function
	| Filter (f, ys, rest) when f x -> Filter (f, x::ys, rest)
	| Filter (f, ys, rest) (* not f x*) -> Filter (f, ys, vstavi x rest)
	| Ostalo ys -> Ostalo (x::ys) 

(*c*)

let rec poisci x veriga =
	match veriga with
	| Filter (f, sez, ver) -> if f x then List.mem x sez else poisci x ver
	| Ostalo sez -> List.mem x sez 

(*d*)

let rec izprazni_filtre = function
	| Filter (f, ys, rest) -> 
			let (empty_rest, elements) = izprazni_filtre rest in
			(Filter (f, [], empty_rest), ys @ elements)
	| Ostalo sez -> (Ostalo [], sez)


(*e*)

(* ZAČETEK MOJE IDEJE:
let rec filtriraj sez veriga =
	match sez with
	| [] -> veriga
	| x :: xs -> filtriraj xs (vstavi x veriga)

(*izprazni_filtre veriga
(prazna_veriga, seznam_elementov)
filtriraj seznam_elementov prazna_veriga
*)

let dodaj_filter f veriga =
	match veriga with
	| Filter (f, ys, rest) -> 
			Filter 
	| Ostalo ys -> Filter (f, )
*)

let dodaj_filter f rest =
	let (empty_rest, elements) = izprazni_filtre rest in
	let filters = Filter (f, [], empty_rest) in
	List.fold_left (fun fil x  -> vstavi x fil) filters elements


(* DRUGA NALOGA *)

