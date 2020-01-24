import random

###############################################################################
# Želimo definirati pivotiranje na mestu za tabelo [a]. Ker bi želeli
# pivotirati zgolj dele tabele, se omejimo na del tabele, ki se nahaja med
# indeksoma [start] in [end].
#
# Primer: za [start = 0] in [end = 8] tabelo
#
# [10, 4, 5, 15, 11, 2, 17, 0, 18]
#
# preuredimo v
#
# [0, 2, 5, 4, 10, 11, 17, 15, 18]
#
# (Možnih je več različnih rešitev, pomembno je, da je element 10 pivot.)
#
# Sestavi funkcijo [pivot(a, start, end)], ki preuredi tabelo [a] tako, da bo
# element [ a[start] ] postal pivot za del tabele med indeksoma [start] in
# [end]. Funkcija naj vrne indeks, na katerem je po preurejanju pristal pivot.
# Funkcija naj deluje v času O(n), kjer je n dolžina tabele [a].
#
# Primer:
#
#     >>> a = [10, 4, 5, 15, 11, 2, 17, 0, 18]
#     >>> pivot(a, 1, 7)
#     3
#     >>> a
#     [10, 2, 0, 4, 11, 15, 17, 5, 18]
###############################################################################

# S = [x0, ..... x(start), x(start + 1), ...., x(end), x(end + 1), ...]
# To hočemo urediti tako, da bo x(start) pivot, ki bo nekje na sredini tiste podtabele, ki jo želimo preurediti. Vsi na levi bodo 
# manjši iz seznama S od x(start), na desni vsi večji iz S.
# Potem izberemo nov pivot na začetku prve polovice, za start in konec nastavimo start in konec prve polovice seznama in uredimo to polovico. Isto
# uredimo še zgornjo polovico. Ponavljamo.

'''def pivot (a, start, end):
    p = a[start]
    seznam = []
    seznam_vecjih = []
    for i in a[: start]:
        seznam.append(i)
    for i in a[(start +1) : (end + 1)]:
        if i <= p:
            seznam.append(i)
        else:
            seznam_vecjih.append(i)
    k = len(seznam)
    seznam.append(p)
    seznam += seznam_vecjih
    for i in a[(end + 1):]:
        seznam.append(i)
    a = seznam
    return seznam'''
# Tole je moja koda, ni OK, ker ne pivotira na mestu, ampak sestavlja nov seznam!!!!!!

def pivot(a, start, end):
    if end <= start:
        #Nothing to do, bad input
        return start
    # We have an index that tells us where the first element larger
    # than the pivot is and we maintain that variant throughout the loop.
    first_larger = start + 1
    for i in range(start, end + 1):
        if a[i] < a[start]:
            # This element needs to end up on the left side of the pivot
            a[first_larger], a[i] = a[i], a[first_larger]
            # Switch it with the 'first_larger' element and update the index.
            first_larger += 1
    # Move the pivot to the right place
    # Swap its position with the last smaller element
    a[start], a[first_larger - 1] = a[first_larger - 1], a[start]
    return first_larger - 1

# a = [10, 4, 5, 15, 11, 2, 17, 0, 18]
# pivot(a, 1, 7)
# Pivotiramo od a[0] = 4 do  vključno a[7] = 0, pivot je 4, first_larger je a[2] = 5. Tega ne premaknemo nikamor.
# Začnemo pri a[1] = 4. Ta ni manjši od 4, zato preskočimo. Isto za a[2] = 5, a[3] = 15, a[4] = 11.
# a[5] = 2 je < 4, zato ga zamenjamo s prvim večjim od 4: z a[2] = 5: 
# [10, 4, 2, 15, 11, 5, 17, 0, 18]
# first_larger je zdaj 3 (<- indeks), a[first_larger] = 15.
# Nadaljujemo. Start in end sta še vedno enaka, a[start] = 4, a[end] = 0, samo first_larger smo povečali. i je zdaj na 6,
# a[6] = 17. Ta je večji od 4, zato ga pustimo na miru. Pridemo do i = 7, a[i] = 0 < 4. Zamenjamo a[first_larger] = 15 in 
# a[i] = 0, dobim:
# [10, 4, 2, 0, 11, 5, 17, 15, 18].
# To je konec zanke, vsi manjši od 4 so zraven 4, potem so pa večji od 4. Radi bi še to 4 postavili na sredino, med manjše
# in večje. Zato vzamemo indeks first_larger - 1 = 2, ki je zadnji element, manjši od 4, a[first_larger - 1] = 0. Zamenjamo
# ga s 4:
# [10, 0, 2, 4, 11, 5, 17, 15, 18].
# Vrnemo first_larger - 1 = 3, na katerem je zdaj pivot: a[first_larger - 1] = 4.


###############################################################################
# V tabeli želimo poiskati vrednost k-tega elementa po velikosti.
#
# Primer: Če je
#
#     >>> a = [10, 4, 5, 15, 11, 3, 17, 2, 18]
#
# potem je tretji element po velikosti enak 5, ker so od njega manši elementi
#  2, 3 in 4. Pri tem štejemo indekse od 0 naprej, torej je "ničti" element 2.
#
# Sestavite funkcijo [kth_element(a, k)], ki v tabeli [a] poišče [k]-ti
# element po velikosti. Funkcija sme spremeniti tabelo [a]. Cilj naloge je, da
# jo rešite, brez da v celoti uredite tabelo [a].
###############################################################################

def kth_element(a, k):
    lower = 0
    upper = len(a) - 1
    while True:
        # See if the first element of the sublist is the k-th
        # Funkcija pivot namreč vrne mesto pivota potem, ko pivotiramo. To je točno to, kar hočemo, ker ničti element nastavimo za pivot,
        # nato pivotiramo, na koncu je ničti element nekje na sredini, vsi manjši so pred njim, večji pa za njim. Dobimo indeks, na katerem
        # je zdaj naš prvi element, ki hkrati pove, kateri po velikosti je (vsi manjši so pred njim, večji za njim).
        candidate_i = pivot(a, lower, upper)
        # candidate_i je indeks, na katerem je pivot po urejanju
        if candidate_i == k:
            return a[candidate_i]
        elif candidate_i < k:
            # We continue searching amongst larger elements
            lower = candidate_i + 1
        else:
            # We continue searching amongst smaller elements
            upper = candidate_i - 1

def kth_element_with_recursion(a, k):
    def kth(lower, upper):
        candidate_i = pivot(a, lower, upper)
        if candidate_i == k:
            return a[candidate_i]
        elif candidate_i < k:
            return kth(candidate_i + 1, upper)
        else:
            return kth(lower, candidate_i - 1)
    return kth(0, len(a)-1)



###############################################################################
# Tabelo a želimo urediti z algoritmom hitrega urejanja (quicksort).
#
# Napišite funkcijo [quicksort(a)], ki uredi tabelo [a] s pomočjo pivotiranja.
# Poskrbi, da algoritem deluje 'na mestu', torej ne uporablja novih tabel.
#
# Namig: Definirajte pomožno funkcijo [quicksort_part(a, start, end)], ki
#        uredi zgolj del tabele [a].
#
#     >>> a = [10, 4, 5, 15, 11, 3, 17, 2, 18]
#     >>> quicksort(a)
#     [2, 3, 4, 5, 10, 11, 15, 17, 18]
###############################################################################
'''
def quicksort_part(a, start, end):
    if start >= end:
        return 'ni dobro'
    elif end == start + 1:
        return a
    else:
        b = pivot(a, start, end)
        zg_meja_spodnjega = b - 1
        sp_meja_zgornjega = b + 1
        return quicksort_part(a, start, end)'''

# Pomožno funkcijo smo napisali kar znotraj glavne:

def quicksort(a):
    def qsort(a, s, e):
        # Check if done (if there is one or less elements)
        if e <= s:
            return 
        # pivotđ
        p_i = pivot(a, s, e)
        # S tem, ko pokličem funkcijo pivot, mi bo že ta uredila seznam tako, da bo pivot na pravem mestu. Mogoče pa vsi manjši in vsi
        # večji en bodo prav urejeni, zato uredimo še spodnji in zgornji del seznama.
        # Sort smaller than pivot
        qsort(a, s, p_i-1)
        # Sort bigger than pivot
        qsort(a, p_i+1, e)
    qsort(a, 0, len(a) - 1)

def test_quicksort():
    for _ in range(1000):
        a = [random.randint(-10000, 100000) for _ in range(100)]
        b1 = a[:]
        b2 = a[:]
        # naša funkcija:
        quicksort(b1)
        # vgrajena Pythonova funkcija:
        b2.sort()
        if b1 != b2:
            return "Not working"

###############################################################################
# Če imamo dve urejeni tabeli, potem urejeno združeno tabelo dobimo tako, da
# urejeni tabeli zlijemo. Pri zlivanju vsakič vzamemo manjšega od začetnih
# elementov obeh tabel. Zaradi učinkovitosti ne ustvarjamo nove tabele, ampak
# rezultat zapisujemo v že pripravljeno tabelo (ustrezne dolžine).
# 
# Funkcija naj deluje v času O(n), kjer je n dolžina tarčne tabele.
# 
# Sestavite funkcijo [zlij(target, begin, end, list_1, list_2)], ki v del 
# tabele [target] med begin in end zlije tabeli [list_1] in [list_2]. V primeru, 
# da sta elementa v obeh tabelah enaka, naj bo prvi element iz prve tabele.
# 
# Primer:
#  
#     >>> list_1 = [1,3,5,7,10]
#     >>> list_2 = [1,2,3,4,5,6,7]
#     >>> target = [-1 for _ in range(len(list_1) + len(list_2))]
#     >>> zlij(target, 0, len(target), list_1, list_2)
#     >>> target
#     [1,1,2,3,3,4,5,5,6,7,7,10]
#
###############################################################################

def zlij(target, begin, end, list_1, list_2):
    l1 = len(list_1)
    l2 = len(list_2)
    i1 = 0
    i2 = 0
    while (i1 < l1 and i2 < l2):
        e1 = list_1[i1]
        e2 = list_2[i2]
        if(e1 < e2):
            target[begin + i1 + i2] = e1
            i1 += 1
        else:
            target[begin + i1 + i2] = e2
            i2 += 1
    while i1 < l1:
        # Tu smo že porabili vse elemente iz list_2, zato samo še dodajamo elemente iz list_1. Tu je i2 že enak l2.
        target[begin + i1 + i2] = list_1[i1]
        i1 += 1 
    while i2 < l2:
        # Tu smo že porabili vse elemente iz list_1, zato samo še dodajamo elemente iz list_2.
        target[begin + i1 + i2] = list_2[i2]
        i2 += 1

###############################################################################
# Tabelo želimo urediti z zlivanjem (merge sort). 
# Tabelo razdelimo na polovici, ju rekurzivno uredimo in nato zlijemo z uporabo
# funkcije [zlij].
#
# Namig: prazna tabela in tabela z enim samim elementom sta vedno urejeni.
#
# Napišite funkcijo [mergesort(a)], ki uredi tabelo [a] s pomočjo zlivanja.
# Za razliko od hitrega urejanja tu tabele lahko kopirate, zlivanje pa je 
# potrebno narediti na mestu.
#
# >>> a = [10, 4, 5, 15, 11, 3, 17, 2, 18]
# >>> mergesort(a)
# [2, 3, 4, 5, 10, 11, 15, 17, 18]
###############################################################################

def mergesort(a):
    def merge_pomozna(sez):
        if sez == []:
            return []
        elif len(sez) == 1:
            return sez
        else:
            middle = len(sez)//2
            seznam1 = sez[0: middle]
            seznam2 = sez[middle :]
            merge_pomozna(seznam1)
            merge_pomozna(seznam2)
            zlij(sez, 0, len(sez), seznam1, seznam2)
    return merge_pomozna(a)
a = [10, 4, 5, 15, 11, 3, 17, 2, 18]
mergesort(a)
