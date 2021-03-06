
(* ========== Vaja 1: Uvod v OCaml  ========== *)

(*----------------------------------------------------------------------------*]
 Funkcija [square] vrne kvadrat podanega celega števila.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # square 2;;
 - : int = 4
[*----------------------------------------------------------------------------*)

let rec square k = k * k

(*----------------------------------------------------------------------------*]
 Funkcija [middle_of_triple] vrne srednji element trojice.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # middle_of_triple (true, false, true);;
 - : bool = false
[*----------------------------------------------------------------------------*)


(* V funkciji damo let ... in. To pomeni, da bomo vse med 'let' in 'in' uporabili na argumentu za 'in'. *)
let rec middle_of_triple trojica = 
  let (x, y, z) = trojica in
  y

let rec middle_of_triple1 (x, y, z) = y


(*----------------------------------------------------------------------------*]
 Funkcija [starting_element] vrne prvi element danega seznama. V primeru
 prekratkega seznama vrne napako.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # starting_element [1; 2; 3; 4];;
 - : int = 1
[*----------------------------------------------------------------------------*)

let rec starting_element seznam =
  match seznam with
    | [] -> failwith "Seznam je prazen!"
    | x :: xs -> x

(*----------------------------------------------------------------------------*]
 Funkcija [multiply] zmnoži vse elemente seznama. V primeru praznega seznama
 vrne vrednost, ki je smiselna za rekurzijo.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # multiply [2; 4; 6];;
 - : int = 48
[*----------------------------------------------------------------------------*)

let rec multiply seznam =
  match seznam with
    | [] -> 1
    | x :: xs -> x * (multiply xs)

let rec multiply' = function
  | [] -> 1
  | x :: xs -> x * (multiply' xs)

(*----------------------------------------------------------------------------*]
 Napišite funkcijo, ekvivalentno python kodi:

  def sum_int_pairs(pair_list):
      if len(pair_list) == 0:
        return []
      else:
        x, y = pair_list[0]
        return [x + y] + sum_int_pairs(pair_list[1:])

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # sum_int_pairs [(1, -2); (3, 4); (0, -0)];;
 - : int list = [-1; 7; 0]
[*----------------------------------------------------------------------------*)

let rec sum_int_pairs seznam_parov = 
  match seznam_parov with
    | [] -> []
    | (x, y) :: xs ->  x + y  :: sum_int_pairs xs 


(*----------------------------------------------------------------------------*]
 Funkcija [get k list] poišče [k]-ti element v seznamu [list]. Številčenje
 elementov seznama (kot ponavadi) pričnemo z 0. Če je k negativen, funkcija
 vrne ničti element. V primeru prekratkega seznama funkcija vrne napako.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # get 2 [0; 0; 1; 0; 0; 0];;
 - : int = 1
[*----------------------------------------------------------------------------*)

let rec get k seznam =
  match seznam with 
   | [] -> failwith "Seznam je prazen!"
   | x :: xs -> if k <= 0 then x else get (k-1) xs

(* Če bi hoteli tu vpisati za k npr. -2, moramo dati okoli oklepaje, ker sta to dva znaka: torej 'get (-2) seznam'*)

let rec get' k seznam =
  match seznam with 
   | [] -> failwith "Seznam je prazen!"
   | x :: xs when k <= 0 -> x 
   | x :: xs (* when k>0 *)-> get (k-1) xs

(*----------------------------------------------------------------------------*]
 Funkcija [double] podvoji pojavitve elementov v seznamu.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # double [1; 2; 3];;
 - : int list = [1; 1; 2; 2; 3; 3]
[*----------------------------------------------------------------------------*)

let rec double seznam =
  match seznam with
    | [] -> []
    | x :: xs -> x :: x :: double xs



(*----------------------------------------------------------------------------*]
 Funkcija [insert x k list] na [k]-to mesto seznama [list] vrine element [x].
 Če je [k] izven mej seznama, ga funkcija doda na začetek oziroma na konec.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # insert 1 3 [0; 0; 0; 0; 0];;
 - : int list = [0; 0; 0; 1; 0; 0]
 # insert 1 (-2) [0; 0; 0; 0; 0];;
 - : int list = [1; 0; 0; 0; 0; 0]
[*----------------------------------------------------------------------------*)

let rec insert a k seznam =
  match seznam with
    | [] -> [a]
    | x :: xs -> if k <= 0 then a  :: xs
                 else x :: insert a (k-1) xs

(*----------------------------------------------------------------------------*]
 Funkcija [divide k list] seznam razdeli na dva seznama. Prvi vsebuje prvih [k]
 elementov, drugi pa vse ostale. Funkcija vrne par teh seznamov. V primeru, ko
 je [k] izven mej seznama, je primeren od seznamov prazen.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # divide 2 [1; 2; 3; 4; 5];;
 - : int list * int list = ([1; 2], [3; 4; 5])
 # divide 7 [1; 2; 3; 4; 5];;
 - : int list * int list = ([1; 2; 3; 4; 5], [])
[*----------------------------------------------------------------------------*)

let rec divide k seznam =
  match seznam with
    | [] -> ([], [])
    | x :: xs when k <= 0 -> ([], x :: xs)
    | x :: xs (* k > 0 *) ->
      let (levi_seznam, desni_seznam) = divide (k-1) xs in
      (x :: levi_seznam, desni_seznam)
  
let rec divide' k  = function
    | [] -> ([], [])
    | x :: xs when k <= 0 -> ([], x :: xs)
    | x :: xs (* k > 0 *) ->
      let (levi_seznam, desni_seznam) = divide (k-1) xs in
      (x :: levi_seznam, desni_seznam)

(*----------------------------------------------------------------------------*]
 Funkcija [rotate n list] seznam zavrti za [n] mest v levo. Predpostavimo, da
 je [n] v mejah seznama.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # rotate 2 [1; 2; 3; 4; 5];;
 - : int list = [3; 4; 5; 1; 2]
[*----------------------------------------------------------------------------*)

let rec rotate n seznam =
  match seznam with
    | [] -> []
    | x :: xs -> if n = 0 then x :: xs
                 else rotate (n - 1) (xs @ [x])


(*----------------------------------------------------------------------------*]
 Funkcija [remove x list] iz seznama izbriše vse pojavitve elementa [x].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # remove 1 [1; 1; 2; 3; 1; 2; 3; 1; 1];;
 - : int list = [2; 3; 2; 3]
[*----------------------------------------------------------------------------*)

let rec remove a seznam =
  match seznam with
    | [] -> []
    | x :: xs -> if x = a then remove a xs
                 else x :: remove a xs

(*----------------------------------------------------------------------------*]
 Funkcija [is_palindrome] za dani seznam ugotovi, ali predstavlja palindrom.
 Namig: Pomagaj si s pomožno funkcijo, ki obrne vrstni red elementov seznama.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # is_palindrome [1; 2; 3; 2; 1];;
 - : bool = true
 # is_palindrome [0; 0; 1; 0];;
 - : bool = false
[*----------------------------------------------------------------------------*)

let rec obrni_vrstni_red seznam =
  match seznam with
    | [] -> []
    | x :: xs -> obrni_vrstni_red xs @ [x]

let rec is_palindrome seznam =
  seznam = obrni_vrstni_red seznam

(*----------------------------------------------------------------------------*]
 Funkcija [max_on_components] sprejme dva seznama in vrne nov seznam, katerega
 elementi so večji od istoležnih elementov na danih seznamih. Skupni seznam ima
 dolžino krajšega od danih seznamov.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # max_on_components [5; 4; 3; 2; 1] [0; 1; 2; 3; 4; 5; 6];;
 - : int list = [5; 4; 3; 3; 4]
[*----------------------------------------------------------------------------*)

let rec max_on_components seznam1 seznam2 =
  match seznam1, seznam2 with
    | [], [] -> []
    | x :: xs, [] -> []
    | [], y :: ys -> []
    | x :: xs, y :: ys -> if x > y then x :: max_on_components xs ys else y :: max_on_components xs ys
  
let rec max_on_components1 list1 list2 =
  match (list1, list2) with
  | (x :: xs, y :: ys) -> max x y :: max_on_components1 xs ys
  | _ -> []
(*----------------------------------------------------------------------------*]
 Funkcija [second_largest] vrne drugo največjo vrednost v seznamu. Pri tem se
 ponovitve elementa štejejo kot ena vrednost. Predpostavimo, da ima seznam vsaj
 dve različni vrednosti.
 Namig: Pomagaj si s pomožno funkcijo, ki poišče največjo vrednost v seznamu.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # second_largest [1; 10; 11; 11; 5; 4; 10];;
 - : int = 10
[*----------------------------------------------------------------------------*)


let rec second_largest seznam =
  let rec largest seznam =
    match seznam with
      | [] -> 0
      | x :: xs -> if x > largest xs then x else largest xs
  in largest (remove (largest seznam) seznam)