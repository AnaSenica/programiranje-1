from functools import lru_cache

###############################################################################
# Napisite funkcijo [najdaljse_narascajoce_podazporedje], ki sprejme seznam in
# poisce najdaljse (ne strogo) narascajoce podzaporedje stevil v seznamu.
#
# Na primer: V seznamu [2, 3, 6, 8, 4, 4, 6, 7, 12, 8, 9] je najdaljse naj vrne
# rezultat [2, 3, 4, 4, 6, 7, 8, 9].
###############################################################################

def najdaljse_narascajoce_podzaporedje(sez):
    
    @lru_cache(maxsize = 256)
    def seznam(prejsnji, i):
        # Tukaj imamo i v argumentih namesto celega sez, ker drugače ne moremo uporabiti tega dekoratorja.
        # SEZNAMI SO PREPOVEDANI KOT ARGUMENTI FUNKCIJ, KI JIH ŽELIMO MEMOIZIRATI!!!
        if i >= len(sez):
            return  []
        # Ali sprejmemo i-ti element? Odvisno od tega, kaj imamo že prej v seznamu. Zato imamo še
        # v argumentih funkcije argument 'prejšnji', ki nam pove, kateri je največji do sedaj.
        elif sez[i] < prejsnji:
            return seznam(prejsnji, i+1)
        else:
            # sez[i] >= prejsnji
            # vzamem element, ki je za i-tim, torej (i+1)-ti element:
            vzamem_prvega = [sez[i]] + seznam(sez[i], i+1)
            # (i+1)-ti element preskočim:
            ne_vzamem_prvega = seznam(prejsnji, i+1)
            if len(vzamem_prvega) > len(ne_vzamem_prvega):
                return vzamem_prvega
            else:
                return ne_vzamem_prvega

    if len(sez) == 0:
        return []
    else:
        return seznam(min(sez), 0)
       
a = [2, 3, 6, 8, 4, 4, 6, 7, 12, 8, 9]
najdaljse_narascajoce_podzaporedje(a)

###############################################################################
# Nepreviden študent je pustil robotka z umetno inteligenco nenadzorovanega.
# Robotek želi pobegniti iz laboratorija, ki ga ima v pomnilniku
# predstavljenega kot matriko števil:
#   - ničla predstavlja prosto pot
#   - enica predstavlja izhod iz laboratorija
#   - katerikoli drugi znak označuje oviro, na katero robotek ne more zaplejati

# Robotek se lahko premika le gor, dol, levo in desno, ter ima omejeno količino
# goriva. Napišite funkcijo [pobeg], ki sprejme matriko, ki predstavlja sobo,
# začetno pozicijo in pa število korakov, ki jih robotek lahko naredi z
# gorivom, in izračuna, ali lahko robotek pobegne. Soba ima vedno vsaj eno
# polje.
#
# Na primer za laboratorij:
# [[0, 1, 0, 0, 2],
#  [0, 2, 2, 0, 0],
#  [0, 0, 2, 2, 0],
#  [2, 0, 0, 2, 0],
#  [0, 2, 2, 0, 0],
#  [0, 0, 0, 2, 2]]
#
# robotek iz pozicije (3, 1) pobegne, čim ima vsaj 5 korakov, iz pozicije (5, 0)
# pa v nobenem primeru ne more, saj je zagrajen.
###############################################################################

soba = [[0, 1, 0, 0, 2],
        [0, 2, 2, 0, 0],
        [0, 0, 2, 2, 0],
        [2, 0, 0, 2, 0],
        [0, 2, 2, 0, 0],
        [0, 0, 0, 2, 2]]


def pobeg(soba, pozicija, koraki):

    @lru_cache(maxsize = 256)
    def premik(pozicija, koraki):

        prvi_primer = (pozicija[0], pozicija[1] + 1)
        drugi_primer = (pozicija[0], pozicija[1] - 1)
        tretji_primer = (pozicija[0] + 1, pozicija[1])
        cetrti_primer = (pozicija[0] - 1, pozicija[1])

        if pozicija[0] < 0 or pozicija[0] > (len(soba)-1):
            return False
        elif pozicija[1] < 0 or pozicija[1] > (len(soba[0])-1):
            return False
        elif soba[pozicija[0]][pozicija[1]] == 2:
            return False
        elif soba[pozicija[0]][pozicija[1]] == 1:
            return True
        elif koraki == 0:
            return False
        else:
            vzamem_prvega = premik(prvi_primer, koraki-1)
            vzamem_drugega = premik(drugi_primer, koraki-1)
            vzamem_tretjega = premik(tretji_primer, koraki-1)
            vzamem_cetrtega = premik(cetrti_primer, koraki-1)
            if vzamem_prvega == True:
                return True
            elif vzamem_drugega == True:
                return True
            elif vzamem_tretjega == True:
                return True
            elif vzamem_cetrtega == True:
                return True
            else:
                return False

    return premik(pozicija, koraki)

pobeg(soba, (3,1), 5)