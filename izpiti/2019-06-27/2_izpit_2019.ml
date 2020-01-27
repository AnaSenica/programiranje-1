(* 1. naloga *)
type complex = { re : float ; im : float }
let test_a = {re = 3.; im = -. 0.5}
(*a*)
let complex_add a b = {re = a.re +. b.re; im = a.im +. b.im}

(*b*)

let complex_conjugate a = { re = a.re ; im = -. a.im}

(*c*)
let list_apply_either pred f g xs =
	let rec pomozna pred f g xs acc =
		match xs with
		| [] -> List.rev acc
		| y :: ys -> 
			if pred (f y) = true then pomozna pred f g ys ((f y)::acc) 
			else pomozna pred f g ys ((g y)::acc)
	in pomozna pred f g xs []

(*d*)
let eva_poly sez s =
	let rec pomozna sez s rezultat stopnja =
		match sez with
		| [] -> rezultat
		| x :: xs -> 
			let rec potenciraj stevilo stopnja acc =
				match stopnja with
				| 0 -> acc
				| _ -> potenciraj stevilo (stopnja - 1) (acc * stevilo)
			in
			pomozna xs s (x*(potenciraj s stopnja 1) + rezultat) (stopnja + 1)
	in pomozna sez s 0 0

let sez = [3; -2; 0; 1]

(* 2. naloga *)

type lastnik = string

type vrt = 
	| Obdelovan of lastnik
	| Oddan of lastnik * (vrt * vrt list)
	| Prost

(*a*)
let vrt_primer = Oddan ( "Kovalevskaya", (Obdelovan "Galois", [Obdelovan "Lagrange"; Prost]) )

(*b*)
let obdelovalec_vrta vrt =
	match vrt with
	| Obdelovan lastnik -> Some lastnik
	| Oddan (lastnik, (vrt, vrt_list)) -> None
	| Prost -> None

(*c*)
let rec globina_oddajanja v =
		match v with
		| Prost -> 0
		| Obdelovan lastnik -> 0
		| Oddan (lastnik, (vrt, vrt_list)) ->
			let globine = List.map globina_oddajanja vrt_list
			in 1 + List.fold_left max (globina_oddajanja vrt) globine
	
(*d*)
let rec v_uporabi v =
	match v with
	| Prost -> false
	| Obdelovan lastnik -> true
	| Oddan (lastnik, (vrt, vrt_list)) ->
		let seznam_vrtov = List.map v_uporabi vrt_list in
		List.fold_left (||) (v_uporabi vrt) seznam_vrtov
	
(*e*)
let rec vsi_najemniki v =
	match v with
		| Prost -> []
		| Obdelovan lastnik -> [lastnik]
		| Oddan (lastnik, (vrt, vrt_list)) ->
			let najemniki = List.map vsi_najemniki vrt_list in
			List.fold_left (@) (lastnik :: (vsi_najemniki vrt)) najemniki

(*f*)
let rec vsi_obdelovalci v =
	match v with
	| Prost -> []
	| Obdelovan lastnik -> [lastnik]
	| Oddan (lastnik, (vrt, vrt_list)) ->
		let najemniki = List.map vsi_obdelovalci vrt_list in
		List.fold_left (@) (vsi_obdelovalci vrt) najemniki

		
			
