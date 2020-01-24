(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 DODATNE VAJE 
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)
type 'a tree =
	| Node of 'a tree * 'a * 'a tree
	| Empty

let leaf x = Node (Empty, x, Empty)

let rec list_of_tree tree =
	match tree with
		| Empty -> []
		| Node (lt, x, rt) -> (list_of_tree lt) @ [x] @ (list_of_tree rt)
    
let rec is_bst t =
  let rec list_is_ordered = function
    | [] | _ :: [] -> true
    | x :: y :: tl -> if x <= y then list_is_ordered (y :: tl) else false
  in t |> list_of_tree |> list_is_ordered

let rec insert s tree =
	match tree with
	| Empty -> leaf s
	| Node (lt, y, rt) when s < y -> Node (insert s lt, y, rt)
	| Node (lt, y, rt) -> Node (lt, y, insert s rt)

let test_tree =
	Node(
		Node (leaf 0, 2, Empty),
		5,
		Node (leaf 6, 7, leaf 11)
	)
(* Vse zgornje funkcije so iz dokumenta iskalna_drevesa. *)

(*----------------------------------------------------------------------------*]
 Funkcija [bst_of_list] iz seznama naredi dvojiško iskalno drevo.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # [11; 6; 7; 0; 2; 5] |> bst_of_list |> is_bst;;
 - : bool = true
[*----------------------------------------------------------------------------*)

let bst_of_list seznam =
    let rec bst_of_list' sez acc_drevo =
        match sez with
        | [] -> acc_drevo
        | x :: xs -> bst_of_list' xs (insert x acc_drevo)
    in bst_of_list' seznam Empty

(*----------------------------------------------------------------------------*]
 Funkcija [tree_sort] uredi seznam s pomočjo pretvorbe v bst in nato nazaj
 v seznam.

 Opomba: Prosim ne uporabljajte te funkcije v praksi.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # tree_sort ["a"; "c"; "f"; "b"; "e"; "d"];;
 - : string list = ["a"; "b"; "c"; "d"; "e"; "f"]
[*----------------------------------------------------------------------------*)

let tree_sort seznam =
    let tree = bst_of_list seznam in
    list_of_tree tree

(*----------------------------------------------------------------------------*]
 Funkcija [follow directions tree] tipa [direction list -> 'a tree -> 'a option]
 sprejme seznam navodil za premikanje po drevesu in vrne vozlišče, do katerega 
 vodi podana pot. Ker navodila morda ne vodijo do nobenega vozlišča v drevesu,
 vrne rezultat kot [option] tip. Ne pozabite definirati tipa [directions].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # follow [Right; Left] test_tree;;
 - : int option = Some 6
 # follow [Right; Left; Right; Right] test_tree;;
 - : int option = None
[*----------------------------------------------------------------------------*)
type directions =
    | Left
    | Right

let rec follow directions tree =
    match tree with
    | Empty -> None
    | Node (lt, x, rt) ->
        match directions with
        | [] -> Some x
        | y :: ys -> if y = Left then follow ys lt else follow ys rt
            

(*----------------------------------------------------------------------------*]
 Funkcija [prune directions tree] poišče vozlišče v drevesu glede na navodila,
 ter izbriše poddrevo, ki se začne v izbranem vozlišču.

 Opozorilo: Pri uporabi [Some Node(l, x, r)] se OCaml pritoži, saj to razume 
 kot [(Some Node)(l, x, r)], zato pravilno postavite potrebne oklepaje.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # prune [Right] test_tree;;
 - : int tree option =
 Some (Node (Node (Node (Empty, 0, Empty), 2, Empty), 5, Empty))
[*----------------------------------------------------------------------------*)

let rec prune directions tree =
    match directions, tree with
    | [], _ -> Some Empty
    | x :: xs, Empty -> None
    | Left :: xs, Node (lt, y, rt) -> (
        match prune xs lt with
        | None -> None
        | Some new_l -> Some (Node(new_l, y, rt)) 
    )
    | Right :: xs, Node(lt, y, rt) -> (
        match prune xs rt with
        |None -> None
        | Some new_l -> Some (Node(lt, y, new_l)))


(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 PHANTOM TREES

 Druga možnost pri brisanju podatkov je, da spremenimo tip s katerim
 predstavljamo drevo. Definirate nov tip fantomskega drevesa, ki poleg podatka,
 levega in desnega poddrevesa hrani še dodatno informacijo o stanju [state], ki
 je bodisi [Exists] če je vozlišče še prisotno in pa [Ghost] če je vozlišče v
 drevesu izbrisano in ga upoštevamo le še kot delitveno vozlišče. Še vedno
 predpostavljamo, da imajo drevesa obliko BST.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)


(*----------------------------------------------------------------------------*]
 Funkcija [phantomize] tipa ['a tree -> 'a phantom_tree] navadnemu drevesu
 priredi ekvivalentno fantomsko drevo.
 Funkcija [kill x ptree] izbriše element [x] v fantomskem drevesu tako, da 
 njegovo stanje nastavi na [Ghost].
 Predpostavite lahko, da v drevesu ni ponovitev elementov.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # phantomize test_tree;;
 - : int phantom_tree =
 P_Node (P_Node (P_Node (P_Empty, 0, P_Empty, Exists), 2, P_Empty, Exists), 5,
 P_Node (P_Node (P_Empty, 6, P_Empty, Exists), 7,
 P_Node (P_Empty, 11, P_Empty, Exists), Exists),
 Exists)

 # bst_of_list [3; 4; 2] |> phantomize |> kill 3 |> kill 6;;
 - : int phantom_tree =
 P_Node (P_Empty, 2,
 P_Node (P_Node (P_Empty, 3, P_Empty, Ghost), 4, P_Empty, Exists), Exists)
[*----------------------------------------------------------------------------*)


(*----------------------------------------------------------------------------*]
 Funkcija [unphantomize] tipa ['a phantom_tree -> 'a tree] fantomskemu drevesu 
 priredi navadno drevo, ki vsebuje zgolj vozlišča, ki še obstajajo. Vrstni red
 vozlišč v končnem drevesu ni pomemben.

 Namig: Lahko uporabite vmesni prehodom na drugo podatkovno strukturo.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # test_tree |> phantomize |> kill 7 |> kill 0 |> kill 5 |> unphantomize;;
 - : int tree = Node (Node (Node (Empty, 2, Empty), 6, Empty), 11, Empty)
[*----------------------------------------------------------------------------*)
