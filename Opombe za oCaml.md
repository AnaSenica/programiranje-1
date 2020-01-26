# POZOR!
Če ti ne najde datotek, ko poskušaš pognati oCaml (run task), potem poglej v json datoteko. Možno je, da imaš tako pri Pythonu
kot pri oCamlu za Windows naštimane tri back-slashe: 
                "command": "python -i \\\"${file}\\\""
Pobriši 2, tako da bo ostalo samo:
                "command": "python -i \"${file}\""
S tremi ti namreč ne najde prave relativne poti do datotek.

# A
# B
# C
# Č
# D
    DINAMIČNO PROGRAMIRANJE
        Koraki: 1. Establish bounds
                2. Make memory
                3. Calculate one value by using recursion with memory
                4. Loop over all values in the correct order
                5. Retrun result
# E


# F

    FOLD LEFT:
        05-funkcijsko-programiranje
        Funkcija <em>fold_left_no_acc f list</em> sprejme seznam [x0; x1; ...; xn] in funkcijo dveh argumentov <em>f</em> in vrne vrednost izračuna
        f(... (f (f x0 x1) x2) ... xn).
            # fold_left_no_acc (^) ["F"; "I"; "C"; "U"; "S"];;
            - : string = "FICUS"

        Razlika med fold_left in fold_right:
        # List.fold_right (-) [1;2;3] 0;;  (* 1 - (2 - (3 - 0)) *)
        - : int = 2
        # List.fold_left (-) 0 [1;2;3];;   (* ((0 - 1) - 2) - 3 *)
        - : int = -6


    FUNKCIJE:
        Definiram jih tako: let plus_dve = (fun x -> x + 2)

        Ali tako: ((+) 4), ampak pazi: Funkcija se izvede tako: 4 + x za x, na katerem uporabim funkcijo.
        To je pomembno za nekomutativne operacije:
            # ((-)2)3;;
            - : int = -1
            # ((-)3)2;;   (* 3 - 2 *)
            - : int = 1
            # ((>)3)8;;   (* 3 > 8 *)
            - : bool = false

# G
# H
# I
# J
# K
# L
# M
# N
# O
# P
# R
    REVERSE:
        Uporabna funkcija za obračanje seznamov, definirano jo imam v 05-funkcijsko-programiranje

# S

    STAKNI NIZA:
        # "D" ^ "F";;
        - : string = "DF"

# Š
# T
# U
# V
# Z

    ZAMIKI:
        Če kdaj VS Code ne zamika lepo vrstic, klikni spodaj v opravilni vrstici desno Spaces oz. Tab size oz. kakroli se izpiše (odvisno od
        tega, ali delam v oCamlu, Markdownu, ...). Za oCaml si nastavim tab size na 2, za Python na 4. Za oCaml sicer ni nujno, je pa lepo, 
        Python pa je zelo občutljiv na pravilne zamike.

# Ž