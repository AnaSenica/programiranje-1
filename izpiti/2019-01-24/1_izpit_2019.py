# 3. naloga

test1 = [2, 4, 1, 2, 1, 3, 1, 1, 5]
test2 = [4, 1, 8, 2, 11, 1, 1, 1, 1, 1]
test3 = [2, 3, 1, 1]

from functools import lru_cache


def pobeg(mocvara): 
    @lru_cache(maxsize=None)
    def pomozna(polje, energija):
        # polje je indeks seznama, na katerem je žaba
        # energija je, kako dolg skok lahko zdaj naredi
    
        if polje >= len(mocvara):
            return 0
        else:
            energija += mocvara[polje]
            return 1 + min([pomozna(polje + d, energija - d) for d in range(1, energija +1)])
    return pomozna(0, 0)

