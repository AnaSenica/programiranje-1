(*1. naloga*)
(*a*)
let podvoji_vsoto a b = 2 * (a + b)

(*b*)
let povsod_vecji (a1, b1, c1) (a2, b2, c2) = 
	if a1 > a2 && b1 > b2 && c1 > c2 then true
	else false

(*c*)
let uporabi_ce_lahko f a =
	match a with
	| None -> None
	| Some x -> Some (f x)

(*d*)
let pojavi_dvakrat a sez =
	let rec pomozna a sez acc =
		match sez with
		| [] -> acc
		| x :: xs when x = a -> pomozna a xs (acc + 1)
		| x :: xs (* ko x ni a *) -> pomozna a xs acc
	in
	if (pomozna a sez 0) = 2 then true else false

(*e*)
let izracunaj_v_tocki a sez_f =
	let rec pomozna a sez_f acc =
		match sez_f with
		| [] -> List.rev acc
		| x :: xs -> pomozna a xs ((x a) :: acc) 
	in pomozna a sez_f []

(*f*)
let eksponent x p =
	let rec pomozna x p acc =
		match p with
		| 0 -> acc
		| _ -> pomozna x (p-1) (acc*x)
	in
	pomozna x p 1

(* 2. naloga *)

(*a*)
type 'a mm_drevo =
	| Empty
	| Node of 'a mm_drevo * 'a * int * 'a mm_drevo

let test = Node (Node (Empty, 1, 3, Empty), 2, 1, Node ( Node (Empty, 4, 1, Empty ), 5, 1, Node (Empty, 8, 2, Empty)))

(*b*)
let rec vstavi drevo a =
	match drevo with
	| Empty -> Node (Empty, a, 1, Empty)
	| Node (lt, x, n, rt) ->
		if x = a then Node (lt, x, n+1, rt) else
		if x < a then Node(lt, x, n, vstavi rt a) else
		(* x > a *) Node (vstavi lt a, x, n, rt)

(*c*)
let rec multimnozica_iz_seznama sez =
	let rec novo_drevo sez drevo =
		match sez with
		| [] -> drevo
		| x :: xs -> novo_drevo xs (vstavi drevo x)
	in novo_drevo sez Empty

(* multimnozica_iz_seznama [2; 5; 1; 4; 1; 1; 2; 8; 8];; *)

(*d*)
let velikost_multimnozice drevo =
	let rec velikost drevo acc =
		match drevo with
		| Empty -> acc
		| Node (lt, x, n, rt) -> n + (velikost lt 0) + (velikost rt 0) 
	in velikost drevo 0

(*e*)
let seznam_iz_multimnozice drevo =
	let rec pomozna drevo acc =
		match drevo with
		| Empty -> acc
		| Node (lt, x, n, rt) ->
			let pripni_element el n =
				let rec pomozna2 el n acc =
					match n with
					| 0 -> acc
					| _ -> pomozna2 el (n-1) (el :: acc)
				in pomozna2 el n []
			in
			(pomozna lt []) @  (pripni_element x n) @ (pomozna rt [])
	in pomozna drevo []

let a = vstavi test 0