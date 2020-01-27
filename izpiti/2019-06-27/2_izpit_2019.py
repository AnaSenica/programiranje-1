# 3. naloga

from functools import lru_cache


zabojniki = [1, 3, 4, 7, 10]


def natovarjanje(nosilnost):
    
    @lru_cache(maxsize=None)
    def pomozna(nosilnost, teza):
        if nosilnost < 0:
            return None
        elif nosilnost == 0:
            return 1
        else:
            def zanka(zac, kon):
                seznam = []
                for i in range(zac, kon):
                    if pomozna(nosilnost-zabojniki[i], zabojniki[i]) != None:
                        seznam.append(pomozna(nosilnost-zabojniki[i], zabojniki[i]))
                    else:
                        pass
                return sum(seznam)
            if teza == 0 or teza == zabojniki[0]:
                return zanka(0, len(zabojniki))
            else:
                for i in range(len(zabojniki)):
                    if teza == zabojniki[i]:
                        return zanka(i, len(zabojniki))
    return pomozna(nosilnost, 0)
