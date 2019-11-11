(* ========== Vaja 3: Definicije Tipov  ========== *)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Pri modeliranju denarja ponavadi uporabljamo racionalna števila. Problemi se
 pojavijo, ko uvedemo različne valute.
 Oglejmo si dva pristopa k izboljšavi varnosti pri uporabi valut.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Definirajte tipa [euro] in [dollar], kjer ima vsak od tipov zgolj en
 konstruktor, ki sprejme racionalno število.
 Nato napišite funkciji [euro_to_dollar] in [dollar_to_euro], ki primerno
 pretvarjata valuti (točne vrednosti pridobite na internetu ali pa si jih
 izmislite).

 Namig: Občudujte informativnost tipov funkcij.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # dollar_to_euro;;
 - : dollar -> euro = <fun>
 # dollar_to_euro (Dollar 0.5);;
 - : euro = Euro 0.4305
[*----------------------------------------------------------------------------*)
type euro = Euro of float
(*konstruktor Euro sprejme float *)
let euro_test = Euro 0.554
type dollar = Dollar of float
let dollar_test = Dollar 0.5

let dollar_to_euro d =
	match d with
	| Dollar f -> Euro (0.91 *. f)

(*dollar_to_euro dollar_test;;*)

let dollar_to_euro2 (Dollar f) = Euro (0.91 *. f)

(*----------------------------------------------------------------------------*]
 Definirajte tip [currency] kot en vsotni tip z konstruktorji za jen, funt
 in švedsko krono. Nato napišite funkcijo [to_pound], ki primerno pretvori
 valuto tipa [currency] v funte.

 Namig: V tip dodajte še švicarske franke in se navdušite nad dejstvom, da vas
        Ocaml sam opozori, da je potrebno popraviti funkcijo [to_pound].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # to_pound (Yen 100.);;
 - : currency = Pound 0.007
[*----------------------------------------------------------------------------*)

type currency =
	| Yen of float
	| Pound of float
	| Krona of float
	| Tolar of float

(*Če kdaj noče lepo zamikati vrstic: spodaj desno na modrem traku kliknem tab size/space size/neki, potem s eodpre orodan vrstica in kliknem nekej s tabs in potem indent 2, kar se uporablja najpogosteje v OCamlu*)

let to_yen = function
	| Yen f -> Yen f
	| Pound f -> Yen (f *. 0.2)
	| Krona f -> Yen (f *. 2.3)
	| Tolar f -> Yen (f *. 230.0 )

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Želimo uporabljati sezname, ki hranijo tako cela števila kot tudi logične
 vrednosti. To bi lahko rešili tako, da uvedemo nov tip, ki predstavlja celo
 število ali logično vrednost, v nadaljevanju pa bomo raje konstruirali nov tip
 seznamov.

 Spomnimo se, da lahko tip [list] predstavimo s konstruktorjem za prazen seznam
 [Nil] (oz. [] v Ocamlu) in pa konstruktorjem za člen [Cons(x, xs)] (oz.
 x :: xs v Ocamlu).
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)



(*----------------------------------------------------------------------------*]
 Definirajte tip [intbool_list] s konstruktorji za:
  1.) prazen seznam,
  2.) člen z celoštevilsko vrednostjo,
  3.) člen z logično vrednostjo.

 Nato napišite testni primer, ki bi predstavljal "[5; true; false; 7]".
[*----------------------------------------------------------------------------*)

type intbool_list =
	| Nil
	| Int of int * intbool_list
	| Bool of bool * intbool_list

let test = Int (5, Bool (true, Bool(false, Int (7, Nil))))

(*----------------------------------------------------------------------------*]
 Funkcija [intbool_map f_int f_bool ib_list] preslika vrednosti [ib_list] v nov
 [intbool_list] seznam, kjer na elementih uporabi primerno od funkcij [f_int]
 oz. [f_bool].
[*----------------------------------------------------------------------------*)

let rec intbool_map f_int f_bool ib_list = 
	match ib_list with
	| Nil -> Nil
	| Int (i, ibl) -> Int (f_int i, intbool_map f_int f_bool ibl)
	| Bool (b, ibl) -> Bool (f_bool b, intbool_map f_int f_bool ibl)

(*----------------------------------------------------------------------------*]
 Funkcija [intbool_reverse] obrne vrstni red elementov [intbool_list] seznama.
 Funkcija je repno rekurzivna.
[*----------------------------------------------------------------------------*)

let rec intbool_reverse ib_list =
	let rec intbool_reverse' ib_list acc =
		match ib_list with 
		| Nil -> acc
		| Int (i, ibl) -> intbool_reverse' ibl (Int (i, acc))
		| Bool (b, ibl) -> intbool_reverse' ibl (Bool (b, acc))
	in
	intbool_reverse' ib_list Nil

(*Kaj bo akumulator? Shranjuje inte in boole, torej točno to, kar smo že definirali*)

(*----------------------------------------------------------------------------*]
 Funkcija [intbool_separate ib_list] loči vrednosti [ib_list] v par [list]
 seznamov, kjer prvi vsebuje vse celoštevilske vrednosti, drugi pa vse logične
 vrednosti. Funkcija je repno rekurzivna in ohranja vrstni red elementov.
[*----------------------------------------------------------------------------*)

let rec intbool_separate ib_list =
	let rec intbool_separate' acc_i acc_b = function
		| Nil -> (acc_i, acc_b)
		| Int (i, ibl) -> intbool_separate' (i :: acc_i) acc_b ibl
		| Bool (b, ibl) -> intbool_separate' acc_i (b :: acc_b) ibl
		in
		intbool_separate' [] [] (intbool_reverse ib_list)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Določeni ste bili za vzdrževalca baze podatkov za svetovno priznano čarodejsko
 akademijo "Effemef". Vaša naloga je konstruirati sistem, ki bo omogočil
 pregledno hranjenje podatkov.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)


(*----------------------------------------------------------------------------*]
 Čarodeje razvrščamo glede na vrsto magije, ki se ji posvečajo. Definirajte tip
 [magic], ki loči med magijo ognja, magijo ledu in magijo arkane oz. fire,
 frost in arcane.

 Ko se čarodej zaposli na akademiji, se usmeri v zgodovino, poučevanje ali
 raziskovanje oz. historian, teacher in researcher. Definirajte tip
 [specialisation], ki loči med temi zaposlitvami.
[*----------------------------------------------------------------------------*)

type magic =
	| Fire
	| Frost
	| Arcane

type specialisation =
	| Historian
	| Teacher
	| Researcher

(*----------------------------------------------------------------------------*]
 Vsak od čarodejev začne kot začetnik, nato na neki točki postane študent,
 na koncu pa SE lahko tudi zaposli.
 Definirajte tip [status], ki določa ali je čarodej:
  a.) začetnik [Newbie],
  b.) študent [Student] (in kateri vrsti magije pripada in koliko časa študira),
  c.) zaposlen [Employed] (in vrsto magije in specializacijo).

 Nato definirajte zapisni tip [wizard] s poljem za ime in poljem za trenuten
 status.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # professor;;
 - : wizard = {name = "Matija"; status = Employed (Fire, Teacher)}
[*----------------------------------------------------------------------------*)

type status =
	| Newbie
	| Student of magic * int
	| Employed of magic * specialisation

type wizard = {name : string; status : status}

let profesor = {name = "Matija"; status = Employed (Fire, Teacher)}

(*----------------------------------------------------------------------------*]
 Želimo prešteti, koliko uporabnikov posamezne od vrst magije imamo na akademiji.
 Definirajte zapisni tip [magic_counter], ki v posameznem polju hrani število
 uporabnikov magije.
 Nato definirajte funkcijo [update counter magic], ki vrne nov števec s
 posodobljenim poljem glede na vrednost [magic].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # update {fire = 1; frost = 1; arcane = 1} Arcane;;
 - : magic_counter = {fire = 1; frost = 1; arcane = 2}
[*----------------------------------------------------------------------------*)

type magic_counter = {fire : int ; frost : int ; arcane : int}

let update counter = function
	| Fire -> {counter with fire = counter.fire + 1}
	| Frost -> {counter with frost = counter.frost + 1}
	| Arcane -> {counter with arcane = counter.arcane + 1}

(*----------------------------------------------------------------------------*]
 Funkcija [count_magic] sprejme seznam čarodejev in vrne števec uporabnikov
 različnih vrst magij.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # count_magic [professor; professor; professor];;
 - : magic_counter = {fire = 3; frost = 0; arcane = 0}
[*----------------------------------------------------------------------------*)

let rec count_magic ws =
	let rec magic_counter counter = function
	| [] -> counter
	| Newbie :: wz -> magic_counter counter wz
	| Student (magic, _) :: wz
	| Employed (magic, _) :: wz ->
		let counter' = update counter magic in 
		magic_counter counter' wz
	in
	magic_counter {fire = 0 ; frost = 0 ; arcane = 0} ws

(* Ni v redu čisto : poglej, kakšnega tipa je ta in kakšnega tipa je spodnja, ki je bolj pravilna*)

let rec count_magic2 ws =
	let rec magic_counter counter = function
	| [] -> counter
	| w :: wz ->
		(match w.status with
			| Newbie -> magic_counter counter wz
			| Student (magic, _) | Employed (magic, _) ->
				let counter' = update counter magic in 
				magic_counter counter' wz)
	in
	magic_counter {fire = 0 ; frost = 0 ; arcane = 0} ws

(*----------------------------------------------------------------------------*]
 Želimo poiskati primernega kandidata za delovni razpis. Študent lahko postane
 zgodovinar po vsaj treh letih študija, raziskovalec po vsaj štirih letih
 študija in učitelj po vsaj petih letih študija.
 Funkcija [find_candidate magic specialisation wizard_list] poišče prvega
 primernega kandidata na seznamu čarodejev in vrne njegovo ime, čim ustreza
 zahtevam za [specialisation] in študira vrsto [magic]. V primeru, da ni
 primernega kandidata, funkcija vrne [None].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # let jaina = {name = "Jaina"; status = Student (Frost, 4)};;
 # find_candidate Frost Researcher [professor; jaina];;
 - : string option = Some "Jaina"
[*----------------------------------------------------------------------------*)

let rec find_candidate = ()
