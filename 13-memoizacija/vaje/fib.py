from functools import lru_cache

# Cilj: izračunajte vrednosti Fibonaccijevega zaporadja za 100, 500, 1000,
# 10**5 in 10**6 člen.
# Za vsako definicijo preizkusite, kako pozne člene lahko izračuante in poglejte,
# zakaj se pojavi problem (neučinkovitost, pregloboka rekurzija,
# premalo spomina ...).

# Definirajte naivno rekurzivno različico.
# Omejitev: Prepočasno.
def fib(n):
    if n <= 1:
        return 1
    else:
        return fib(n-1) + fib(n-2)

# Z uporabo dekoratorja izboljšajte naivno različico.
# Omejitev: Preseže največjo dovoljeno globino rekurzija za ~350.
from functools import lru_cache

@lru_cache(maxsize = 250)
def fib_cache(n):
    if n <= 1:
        return 1
    else:
        return fib(n-1) + fib(n-2)

# Nariši drevo klicov za navadno rekurzivno fib funkcijo pri n=5 in
# ugotovi, kateri podproblemi so klicani večkrat.
#                        5
#                     /     \
#                    3       4
#                  /  \     /  \
#                 2    1   3    2
#                /\       /\    /\
#               1  0     2  1  1  0
#                       /\ 
#                      1  0
#      
# Definirajte rekurzivno memoizirano funkcijo fib brez uporabe dekoratorja.
# Omejitev: Preseže največjo dovoljeno globino rekurzija za ~1000.


def fib_memo_rec2(n):
    # Naredim ravno prav velik seznam, v katerega shranjujem vrednosti. Mora biti dolg vsaj 2??
    seznam = [None for i in range(max(2, n+1))]
    def pomozna(m):
        if m <= 2:
            return m
        else:
            if seznam[m] == None:
                seznam[m] = pomozna(m-1) + pomozna(m-2)
                return seznam[m]
            else:
                return seznam[m]
    return pomozna(n)


# Na katere podprobleme se direktno skicuje rekurzivna definicija fib?

# Definirajte fib, ki gradi rezultat od spodaj navzgor (torej računa in si zapomni
# vrednosti od 1 proti n.)

def fib_memo_iter(n):
    seznam = [None for i in range(max(2, n+1))]
    for i in range(n+1):
        if i <= 2:
            seznam[i] = i
        else:
            seznam[i] = seznam[i-1] + seznam[i-2]
    return seznam[n]

# Izboljšajte prejšnjo različico tako, da hrani zgolj rezultate, ki jih v
# nadaljevanju nujno potrebuje.
def fib_iter(n):
    if n < 2:
        return n
    else:
        x_2 = 0
        x_1 = 1
        for i in range(2,n+1):
            x = x_1 + x_2
            x_2 = x_1
            x_1 = x
        return x