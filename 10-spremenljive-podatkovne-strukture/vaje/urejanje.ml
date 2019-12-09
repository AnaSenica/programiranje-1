(* ========== Vaje 5: Urejanje  ========== *)


(*----------------------------------------------------------------------------*]
 Funkcija [randlist len max] generira seznam dolžine [len] z naključnimi
 celimi števili med 0 in [max].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # let l = randlist 10 10 ;;
 val l : int list = [0; 1; 0; 4; 0; 9; 1; 2; 5; 4]
[*----------------------------------------------------------------------------*)

let rec randlist len max =
    let rec listgen len acc =
        if len <= 0 then
            acc
        else listgen (len-1) (Random.int max :: acc)
    in 
    listgen len [] 

(* Dobimo:
# randlist 100 100;;
- : int list =
[17; 0; 13; 29; 13; 56; 1; 93; 58; 95; 89; 88; 33; 78; 46; 24; 92; 57; 95;  
 69; 71; 53; 33; 36; 28; 35; 56; 22; 24; 68; 91; 36; 35; 70; 40; 82; 83; 19;
 52; 65; 22; 38; 86; 76; 69; 9; 51; 24; 58; 88; 18; 54; 46; 20; 43; 84; 70; 
 59; 99; 20; 63; 83; 60; 97; 97; 57; 11; 55; 12; 49; 70; 0; 3; 96; 44; 23;  
 23; 14; 93; 89; 69; 28; 6; 1; 12; 15; 78; 49; 85; 17; 70; 21; 20; 4; 0; 39;
 41; 82; 85; 44]
#
*)



(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Sedaj lahko s pomočjo [randlist] primerjamo našo urejevalno funkcijo (imenovana
 [our_sort] v spodnjem primeru) z urejevalno funkcijo modula [List]. Prav tako
 lahko na manjšem seznamu preverimo v čem je problem.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 let test = (randlist 100 100) in (our_sort test = List.sort compare test);;
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

let rec tester our_sort len =
    (*luškano za izpit*)
    (* Pove, ali funkcija [our_sort] pravilno uredi naključen seznam dolžine [len] *)
    let test = randlist len 10000 in
    our_sort test = List.sort compare test

(*
# tester (List.sort compare) 10000;;
- : bool = true
# tester (fun x -> x) 3;;
- : bool = false
# tester (fun x -> x) 3;;
- : bool = false
# tester (fun x -> x) 3;;
- : bool = false
# tester (fun x -> x) 3;;
- : bool = true
# tester (fun x -> x) 3;;
- : bool = false
(Nekajkrat je bilo treba to napisati v terminal)
*)

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*]
 Urejanje z Vstavljanjem
[*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

(*----------------------------------------------------------------------------*]
 Funkcija [insert y xs] vstavi [y] v že urejen seznam [xs] in vrne urejen
 seznam. 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # insert 9 [0; 2];;
 - : int list = [0; 2; 9]
 # insert 1 [4; 5];;
 - : int list = [1; 4; 5]
 # insert 7 [];;
 - : int list = [7]
[*----------------------------------------------------------------------------*)

let rec insert y xs =
  match xs with
  | [] -> [y]
  | x :: xs -> 			
		if x < y then x :: (insert y xs)
		else y :: x :: xs
	
let insert_tlrec y xs =
	let rec insert'  acc = function
  	| [] -> List.rev (y :: acc)
		(*val rev : 'a list -> 'a list
		List reversal.*)
  	| x :: xs -> 			
			if x < y then 
				insert' (x :: acc) xs
			else
				(*List.rev_append xs ys ~ (List.rev xs) @ ys, ampak repno rekurzivna: val rev_append : 'a list -> 'a list -> 'a list
				List.rev_append l1 l2 reverses l1 and concatenates it to l2. This is equivalent to List.rev l1 @ l2, but rev_append is tail-recursive and more efficient.*)
				List.rev_append (y :: acc) (x :: xs)
	in
	insert' [] xs

(*
# insert_tlrec 3 [1; 2; 4];;
- : int list = [1; 2; 3; 4]
# insert_tlrec 1 [];;
- : int list = [1]
*)

(*----------------------------------------------------------------------------*]
 Prazen seznam je že urejen. Funkcija [insert_sort] uredi seznam tako, da
 zaporedoma vstavlja vse elemente seznama v prazen seznam.
[*----------------------------------------------------------------------------*)

let insert_sort xs = 
	List.fold_left (fun ys y -> insert_tlrec y ys) [] xs
(*
fold_left : ('a -> 'b -> 'a) -> 'a -> 'b list -> 'a
List.fold_left f a [b1; ...; bn] is f (... (f (f a b1) b2) ...) bn.
*)

(* Lahko tudi brez List.fold_left, na tak način:*)
let rec insert_sort_bad = function
	| [] -> []
	| x :: xs -> insert x (insert_sort_bad xs)

let insert_sort_tlrec xs =
	let rec sort' acc = function
	| [] -> acc
	| x :: xs -> sort' (insert_tlrec x acc) xs
	in
	sort' [] xs

(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*]
 Urejanje z Izbiranjem
[*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

(*----------------------------------------------------------------------------*]
 Funkcija [min_and_rest list] vrne par [Some (z, list')], tako da je [z]
 najmanjši element v [list] in seznam [list'] enak [list] z odstranjeno prvo
 pojavitvijo elementa [z]. V primeru praznega seznama vrne [None]. 
[*----------------------------------------------------------------------------*)

let rec min_and_rest = function
	| [] -> None
	| x :: xs -> 
		let rec get_min acc rest = function
			| [] -> (acc, rest)
			| y :: ys -> 
				if acc < y then
					get_min acc (y :: rest) ys
				else
				get_min y (acc :: rest) ys
			(* VRSTNI RED ELEMENTOV V REST BO MORDA DRUGAČEN! 
			(but we don't care)*)
		in
		Some (get_min x [] xs)
			
		

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Pri urejanju z izbiranjem na vsakem koraku ločimo dva podseznama, kjer je prvi
 že urejen, drugi pa vsebuje vse elemente, ki jih je še potrebno urediti. Nato
 zaporedoma prenašamo najmanjši element neurejenega podseznama v urejen
 podseznam, dokler ne uredimo vseh. 

 Če pričnemo z praznim urejenim podseznamom, vemo, da so na vsakem koraku vsi
 elementi neurejenega podseznama večji ali enaki elementom urejenega podseznama,
 saj vedno prenesemo najmanjšega. Tako vemo, da moramo naslednji najmanjši člen
 dodati na konec urejenega podseznama.
 (Hitreje je obrniti vrstni red seznama kot na vsakem koraku uporabiti [@].)
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Funkcija [selection_sort] je implementacija zgoraj opisanega algoritma.
 Namig: Uporabi [min_and_rest] iz prejšnje naloge.
[*----------------------------------------------------------------------------*)

let rec selection_sort xs =
	match min_and_rest xs with
		| None -> []
		| Some (m, rest) -> m :: selection_sort rest

(*let rec selection_sort_tlrec xs = 
	failwith ???*)


(*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*]
 Urejanje z Izbiranjem na Tabelah
[*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Pri delu z tabelami (array) namesto seznami, lahko urejanje z izbiranjem 
 naredimo "na mestu", t.j. brez uporabe vmesnih kopij (delov) vhoda. Kot prej
 tabelo ločujemo na že urejen del in še neurejen del, le da tokrat vse elemente
 hranimo v vhodni tabeli, mejo med deloma pa hranimo v spremenljivki
 [boundary_sorted]. Na vsakem koraku tako ne izvlečemo najmanjšega elementa
 neurejenga dela tabele temveč poiščemo njegov indeks in ga zamenjamo z
 elementom na meji med deloma (in s tem dodamo na konec urejenega dela).
 Postopek končamo, ko meja doseže konec tabele.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Funkcija [swap a i j] zamenja elementa [a.(i)] in [a.(j)]. Zamenjavo naredi
 na mestu in vrne unit.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # let test = [|0; 1; 2; 3; 4|];;
 val test : int array = [|0; 1; 2; 3; 4|]
 # swap test 1 4;;
 - : unit = ()
 # test;;
 - : int array = [|0; 4; 2; 3; 1|]
[*----------------------------------------------------------------------------*)

(* Ne naredi tako, ker dobim tole: 
# let a = [|1; 2; 3; 4|];;
val a : int array = [|1; 2; 3; 4|]
# swap_narobe a 2 1;;
- : unit = ()
# a;;
- : int array = [|1; 2; 2; 4|]
*)

let swap_narobe a i j =
	a.(i) <- a.(j);
	a.(j) <- a.(i)

(* PRAVILNO JE TAKO: *)

let swap1 a i j =
	let ai = a.(i) in
	a.(i) <- a.(j);
	a.(j) <- ai

(*
# let a = [|1; 2; 3; 4|];; 
val a : int array = [|1; 2; 3; 4|]
# swap1 a 1 2;;
- : unit = ()
# a;;
- : int array = [|1; 3; 2; 4|]
*)

let swap2 a i j =
	let () = a.(i) <- a.(j) in
	let () = a.(j) <- a.(i) in
	()

(*
# let a = [|1; 2; 3; 4|];; 
val a : int array = [|1; 2; 3; 4|]
# a.(3) = 5;;
- : bool = false
*)

(*----------------------------------------------------------------------------*]
 Funkcija [index_min a lower upper] poišče indeks najmanjšega elementa tabele
 [a] med indeksoma [lower] and [upper] (oba indeksa sta vključena).
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 index_min [|0; 2; 9; 3; 6|] 2 4 = 3
[*----------------------------------------------------------------------------*)

let index_min a lower upper =
	let rec search mini i =
		if i > upper then
			(* Končali iskanje. *)
			mini
		else if a.(i) < a.(mini) then
			(* Našli nov najmnajši element, posodobi indeks minimuma. *)
			search i (i + 1)
		else
			(* Nezanimiv element, išči naprej. *)
			search mini (i + 1)
	in
	(* Začni iskati pri [lower], kjer je najmanjši do sedaj videni element prav tako na indeksu [lower]. *)
	search lower lower


(*----------------------------------------------------------------------------*]
 Funkcija [selection_sort_array] implementira urejanje z izbiranjem na mestu. 
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 Namig: Za testiranje uporabi funkciji [Array.of_list] in [Array.to_list]
 skupaj z [randlist].
[*----------------------------------------------------------------------------*)

let selection_sort_array a =
	let len = Array.length a in
	let rec sorter lower =
		if lower >= len then
			(* Everything is sorted! *)
			() 
		else
			(* Find the minimal elemnt in the rest of the list and swap it with the element on the lower end of the
			'to be sorted' part of the list. *)
			let mini = index_min a lower (len - 1) in
			let () = swap1 a lower mini in
			(* Sort the rest of the list. *)
			sorter (lower + 1)
	in
	sorter 0

let rec array_tester our_sort len =
	let test = randlist len 10000 in
	let test_array = Array.of_list test in
	let () = our_sort test_array in
	Array.to_list test_array = List.sort compare test