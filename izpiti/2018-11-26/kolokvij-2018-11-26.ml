(* -------- 1 -------- *)

let rec sestej seznam =
  let rec sestej' seznam acc =
    match seznam with
			| [] -> acc
			| x :: xs -> sestej' xs (x + acc)
	in sestej' seznam 0

(* -------- 2 -------- *)

let rec je_narascajoce seznam =
	match seznam with
		| [] -> true
		| x :: [] -> true
		| x :: y :: xs -> if x <= y then je_narascajoce ( y :: xs ) else false

(* -------- 3 -------- *)
(*Napišite funkcijo, ki vstavi celo število v urejen seznam celih števil. Na primer vstavljanje 4 v
[0; 1; 1; 42] vrne [0; 1; 1; 4; 42].
Cˇ e na tak nacˇin zaporedno vstavljamo elemente v prazen seznam, je rezultat prav tako urejen
seznam. S pomoˇcjo tega dejstva napišite funkcijo, ki sprejme seznam celih števil in vrne urejen
seznam, ki vsebuje enaka števila.*)

let rec vstavi seznam stevilo =
	match seznam with
		| [] -> stevilo :: []
		| x :: xs -> if stevilo <= x then stevilo :: x :: xs else x :: (vstavi xs stevilo)

let rec urejen seznam = 
	match seznam with
		| [] -> []
		| x :: xs -> vstavi (urejen xs) x

(* -------- 4 -------- *)
(*Urejanje z vstavljanjem, ki smo ga definirali v prejšnji nalogi, ni odvisno od dejstva, da je vhod
seznam celih števil. Napišite novo funkcijo za urejanje, ki kot argument poleg seznama elementov
dobi tudi funkcijo cmp. Funkcija cmp sprejme x in y in pove, ali je x manjši kot y. Na primer funkcija
fun j k -> not (j < k) obrne vrstni red ureditve celih števil. Cˇ e jo skupaj s seznamom
[0; 1; 1; 42] podamo kot vhod naše funkcije za urejanje, nam ta vrne [42; 1; 1; 0].*)

let rec urejanje_nova seznam stevilo cmp =
	match seznam with
		| [] -> [stevilo]
  	| x :: xs -> if cmp stevilo x then stevilo :: seznam else x :: (urejanje_nova xs stevilo cmp)

let rec sort cmp seznam =
	match seznam with
		| [] -> []
		| x :: xs -> urejanje_nova (sort cmp xs) x cmp  


(* -------- 5 -------- *)
type priority = 
	| Top
	| Group of int

type status =
	| Staff
	| Passenger of priority

type flyer = { status : status ; name : string }

let flyers = [ {status = Staff; name = "Quinn"}
             ; {status = Passenger (Group 0); name = "Xiao"}
             ; {status = Passenger Top; name = "Jaina"}
             ; {status = Passenger (Group 1000); name = "Aleks"}
             ; {status = Passenger (Group 1000); name = "Robin"}
             ; {status = Staff; name = "Alan"}
             ]

(* -------- 6 -------- *)
(*Napišite funkcijo, ki uredi seznam potnikov v zaporedje za vkrcavanje tako, da je prvo na vrsti
osebje, nato navadni potniki vrhovne prioritete, sledijo pa navadni potniki razporejeni padajoˇce
glede na njihovo prioritetno skupino (znotraj skupin vrstni red ni pomemben). Zaporedje predstavimo
s seznamom.
Primer zaporedja za vkrcavanje konstruiran iz zgornjega primera je:
[{status = Staff; name = "Quinn"};
{status = Staff; name = "Alan"};
{status = Passenger Top; name = "Jaina"};
{status = Passenger (Group 1000); name = "Robin"};
{status = Passenger (Group 1000); name = "Aleks"};
{status = Passenger (Group 0); name = "Xiao"}]
*)

let funkcija x y =
	match x.status, y.status with
		| Staff, _ -> true
		| _, Staff -> false
		| Passenger Top, Passenger _ -> true
		| Passenger _, Passenger Top -> false
		| Passenger (Group j), Passenger (Group k) -> j > k

let vkrcavanje seznam = sort funkcija seznam


(* -------- 7 -------- *)

(*Napišite funkcijo, ki sprejme seznam potnikov in ga razdeli v bloke, ki vsebujejo potnike enake
prioritete (prioritete lahko primerjate z OCamlovo vgrajeno enakostjo =). Bloke vrnemo v obliki
seznama seznamov, kjer naj bodo bloki urejeni glede na prioriteto.
Za zgornji primer torej dobimo:
[[ {status = Staff; name = "Alan"};
{status = Staff; name = "Quinn"} ];
[ {status = Passenger Top; name = "Jaina"} ];
[ {status = Passenger (Group 1000); name = "Aleks"};
{status = Passenger (Group 1000); name = "Robin"} ];
[ {status = Passenger (Group 0); name = "Xiao"} ]]*)

