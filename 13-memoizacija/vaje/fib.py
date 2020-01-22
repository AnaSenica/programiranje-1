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
#                 2   1    3    2
#                /\       /\    /\
#               1  0     2  1  1 0
#      
# Definirajte rekurzivno memoizirano funkcijo fib brez uporabe dekoratorja.
# Omejitev: Preseže največjo dovoljeno globino rekurzija za ~1000.
spomin = {}
def fib_memo_rec(n):
    if n <= 1:
        return 1
    else:
        if n - 1 in spomin.keys() and  n - 2 in spomin.keys():
            rezultat = spomin[n-1] + spomin[n-2]
            spomin[n] = rezultat
            print(spomin)
            return rezultat
        else:
            a = fib(n-1)
            b = fib(n-2)
            spomin[n-1] = a
            spomin[n-2] = b
            print(spomin)
            return  a + b


# Na katere podprobleme se direktno skicuje rekurzivna definicija fib?

# Definirajte fib, ki gradi rezultat od spodaj navzgor (torej računa in si zapomni
# vrednosti od 1 proti n.)

def fib_memo_iter(n):
    pass

# Izboljšajte prejšnjo različico tako, da hrani zgolj rezultate, ki jih v
# nadaljevanju nujno potrebuje.
def fib_iter(n):
    pass