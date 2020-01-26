# 3. naloga
# Na začetku je v mestu 0 in ima 0 evrov, končati mora v mestu 5.
from functools import lru_cache
primer = [[(1, 10), (3, -10)], [(2, 10), (5, -20)], [(3, -10)], [(4, 15)], [(5, 0)]]

'''def pot(seznam_mest):
    mesto_odresitve = len(seznam_mest)

    def premik(trenutno_mesto, denar, prepotovana_pot): 
        if trenutno_mesto == mesto_odresitve:
            return (denar,prepotovana_pot)
        else:
            moznosti = seznam_mest[trenutno_mesto]
            naslednje_mesto = []
            for i in moznosti:
                mesto = i[0]
                cena = i[1]
                prepotovana_pot.append(mesto)
                korak = (premik(mesto, cena + denar, prepotovana_pot))
                if korak[0] >= 0:
                    naslednje_mesto.append(korak[1])
                else:
                    pass
                return min(naslednje_mesto)
    premik(0, 0, []) if premik(0, 0, []) != [] else None

pot(primer)'''

def pobeg(pot):

    @lru_cache(maxsize=None)
    def pobeg(i, denar):
        if i >= len(pot) and denar >= 0:
            return [i]
        elif i >= len(pot):
            return None
        else:
            moznosti = []
            for (skok, stroski) in pot[i]:
                beg = pobeg(skok, denar + stroski)
                if beg is not None:
                    moznosti.append(beg)
            if len(moznosti) == 0:
                return None
            else:
                return [i] + sorted(moznosti, key=len)[0]

    return pobeg(0, 0)