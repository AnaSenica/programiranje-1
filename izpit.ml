(* =================== *)

(* 1. naloga: funkcije *)

(* =================== *)



let is_root st1 st2 =
	if st1 < 0 then false else if st1 * st1 = st2 then true else false
	



let pack3 a b c =
	(a, b, c)



let rec sum_if_not pogoj seznam = 
	let rec recsum_if_not' pogoj seznam acc =
		match seznam with
			| [] -> acc
			| x :: xs -> if pogoj x then recsum_if_not' pogoj xs acc else recsum_if_not' pogoj xs (x + acc)
	in recsum_if_not' pogoj seznam 0



let rec obrni seznam =
	let rec obrni' seznam acc =
		match seznam with
			| [] -> acc
			| x :: xs -> obrni' xs (x :: acc)
	in obrni' seznam []



let rec apply funkcije elementi = 
	let rec apply' funkcije elementi acc1 =
		match elementi with
			| [] -> obrni acc1
			| x :: xs -> apply' funkcije xs 
				((let rec apply2 funkcije element acc2 =
				match funkcije with
					| [] -> obrni acc2
					| f :: fs -> apply2 fs element ((f element) :: acc2)
				in apply2 funkcije x []) :: acc1)
	in apply' funkcije elementi []


(* ======================================= *)

(* 2. naloga: podatkovni tipi in rekurzija *)

(* ======================================= *)



type vrsta_srecanja = 
	| Predavanja
	| Vaje

type srecanje = {predmet : string; vrsta : vrsta_srecanja; trajanje: int}

type urnik = srecanje list list



let vaje =  {predmet = "Analiza 2a"; vrsta = Vaje; trajanje = 3}

let predavanje  = {predmet = "Programiranje 1"; vrsta = Predavanja; trajanje = 2}



let urnik_profesor  = [[{predmet = "Fizika2"; vrsta = Vaje; trajanje = 2}]; [{predmet = "Fizika2"; vrsta = Predavanja; trajanje = 1}]; []; []; []; [{predmet = "Fizika2"; vrsta = Vaje; trajanje = 1}]; []]



(*let rec je_preobremenjen urnik = 
	let rec je_preobremenjen' urnik acc =
		match urnik with
			| [] -> acc
			| x :: xs -> je_preobremenjen' xs acc
				let rec je_preobremenjen_dan dan acc2 =
					match dan with
						| [] -> acc2
						| y :: ys -> 
				in je_preobremenjen_dan x false
	in je_preobremenjen' urnik false*)


let rec bogastvo urnik =
	let rec bogastvo' urnik acc =
		match urnik with 
			| [] -> acc
			| x :: xs -> bogastvo' xs 
				((let rec bogastvo_v_enem_dnevu dan acc =
					match dan with 
						| [] -> acc
						| y :: ys -> if y.vrsta = Vaje then bogastvo_v_enem_dnevu ys ((y.trajanje * 1) + acc) else bogastvo_v_enem_dnevu ys ((y.trajanje * 2) + acc)
				in bogastvo_v_enem_dnevu x 0) + acc)
	in bogastvo' urnik 0