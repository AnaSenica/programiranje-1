import csv
import os
import re
import requests

###############################################################################
# Najprej definirajmo nekaj pomožnih orodij za pridobivanje podatkov s spleta.
###############################################################################

# definiratje URL glavne strani bolhe za oglase z mačkami
cats_frontpage_url = 'http://www.bolha.com/zivali/male-zivali/macke/'
# mapa, v katero bomo shranili podatke
cat_directory = 'macke'
# ime datoteke v katero bomo shranili glavno stran
frontpage_filename = 'macke_stran.html'
# ime CSV datoteke v katero bomo shranili podatke
csv_filename = 'macke.csv'


def download_url_to_string(url):
    """Funkcija kot argument sprejme niz in puskuša vrniti vsebino te spletne
    strani kot niz. V primeru, da med izvajanje pride do napake vrne None.
    """
    try:
        # del kode, ki morda sproži napako. To je del kode, ki requesta spletno stran. get() nam vrne nek response, .text to razpakira: torej dobimo tekst
        page_content = requests.get(url).text
    except requests.exceptions.RequestException as e:
        #ujeli smo nas error kot e, ga sprintamo, da vidimo, kaj je narobe. Nastavili bomo, da je stran prazna, lahko bi pa tudi samo prekinili delovanje funkcije.
        # v nasem primeru bo se vedno ujelo vse strani, razen tistih nekja, ki dvignejo napako. S temi stranmi se bomo potem ukvarjali posebej.
        print(e)
        page_content = ''
        # koda, ki se izvede pri napaki
        # dovolj je če izpišemo opozorilo in prekinemo izvajanje funkcije
    # nadaljujemo s kodo če ni prišlo do napake
    return page_content


def save_string_to_file(text, directory, filename):
    """Funkcija zapiše vrednost parametra "text" v novo ustvarjeno datoteko
    locirano v "directory"/"filename", ali povozi obstoječo. V primeru, da je
    niz "directory" prazen datoteko ustvari v trenutni mapi.
    """
    os.makedirs(directory, exist_ok=True)
    path = os.path.join(directory, filename)
    with open(path, 'w', encoding='utf-8') as file_out:
        file_out.write(text)
    return None


# Definirajte funkcijo, ki prenese glavno stran in jo shrani v datoteko.


def save_frontpage(page, directory, filename):
    """Funkcija shrani vsebino spletne strani na naslovu "page" v datoteko
    "directory"/"filename"."""
    content = download_url_to_string(page)
    save_string_to_file(content, directory, filename)
    return

#Na koncu v terminalu poklicem save_frontpage(cats_frontpage_url, cat_directory, frontpage_filename), pojavi se nova mapa macke z datoteko macke_stran.html
# Zdaj je to zakomentirano, ker sem enkrat že poklicala to funkcijo in že mam to mojo datoteko.

###############################################################################
# Po pridobitvi podatkov jih želimo obdelati.
###############################################################################


def read_file_to_string(directory, filename):
    """Funkcija vrne celotno vsebino datoteke "directory"/"filename" kot niz"""
    path = os.path.join(directory, filename)
    with open(path, 'r', encoding='utf8') as datoteka1:
        return datoteka1.read()


# Definirajte funkcijo, ki sprejme niz, ki predstavlja vsebino spletne strani,
# in ga razdeli na dele, kjer vsak del predstavlja en oglas. To storite s
# pomočjo regularnih izrazov, ki označujejo začetek in konec posameznega
# oglasa. Funkcija naj vrne seznam nizov.


def page_to_ads(page_content):
    """Funkcija poišče posamezne oglase, ki se nahajajo v spletni strani in
    vrne njih seznam"""
    # (.*?) pomeni katerikoli znak, od 0 naprej, ? pomeni, da ni požrešen način. Torej pobere čim manj, kolikor je možno.
    # modul .DOTALL na knjižnici re poskrbi, da pika pomeni katerikoli znak, tudi presledke (če ni dotall, pika pomeni katerikoli znak razen presledkov)
    izraz = re.compile(r'<div class="ad">(.*?)<div class="clear">', re.DOTALL)
    return [m.group(0) for m in re.finditer(izraz, page_content)]

# Da preverim delovanje te funkcije, vstavim npr. tole: niz = ' <div class="ad"><div class="clear"></div></div><div class="ad"><div class="coloumn image"><td><a titl<div class="clear">'

# Definirajte funkcijo, ki sprejme niz, ki predstavlja oglas, in izlušči
# podatke o imenu, ceni in opisu v oglasu.


def get_dict_from_ad_block(blok):
    """Funkcija iz niza za posamezen oglasni blok izlušči podatke o imenu, ceni
    in opisu ter vrne slovar, ki vsebuje ustrezne podatke
    """
    izraz = re.compile(
        r'<h3><a title="(?P<ime>.*?)"'
        r'.*?>(?P<opis>.*?)</a></h3>'
        r'.*?class="price">(<span>)?(?P<cena>.*?)( €</span>)?</div',
        re.DOTALL
    )
    podatki = re.search(izraz, blok)
    # .groupdict() vrne slovar POIMENOVANIH spremenljivk 
    slovar = podatki.groupdict()
    return slovar

# Da preverim delovanje te funkcije, vstavim npr. tole:
#'<span class="flag_newAd"></span>         </div><div class="coloumn content"><h3><a title="Gusarka Loti (DZZŽ Kranj)" href="http://www4103">Gusarka Loti (DZZŽ Kranj)</a></h3><div class="price">Po dogovoru</div>  <div class="clear"></div>  <div class="miscellaneous">'



# Definirajte funkcijo, ki sprejme ime in lokacijo datoteke, ki vsebuje
# besedilo spletne strani, in vrne seznam slovarjev, ki vsebujejo podatke o
# vseh oglasih strani.


def ads_from_file(ime_datoteke, lokacija_datoteke):
    """Funkcija prebere podatke v datoteki "directory"/"filename" in jih
    pretvori (razčleni) v pripadajoč seznam slovarjev za vsak oglas posebej."""
    stran = read_file_to_string(lokacija_datoteke, ime_datoteke)
    oglasi = page_to_ads(stran)
    seznam = [get_dict_from_ad_block(oglas) for oglas in oglasi]
    return seznam

def ads_frontpage():
    return ads_from_file(frontpage_filename, cat_directory)

###############################################################################
# Obdelane podatke želimo sedaj shraniti.
###############################################################################


def write_csv(fieldnames, rows, directory, filename):
    """
    Funkcija v csv datoteko podano s parametroma "directory"/"filename" zapiše
    vrednosti v parametru "rows" pripadajoče ključem podanim v "fieldnames"
    """
    # makedirs() ustvari rekurzivno pot??
    os.makedirs(directory, exist_ok=True)
    path = os.path.join(directory, filename)
    with open(path, 'w', encoding='utf8') as csv_file:
        #  DictWriter ustvari objekt, ki deluje kot navaden writer, a za izhodne
        # vrstice naredi slovarje. Fieldnames parameter so ključi, ki določijo
        # vrstni red, v katerem so vrednosti slovarja podane writerow().
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)
    return None


# Definirajte funkcijo, ki sprejme neprazen seznam slovarjev, ki predstavljajo
# podatke iz oglasa mačke, in zapiše vse podatke v csv datoteko. Imena za
# stolpce [fieldnames] pridobite iz slovarjev.


def write_cat_ads_to_csv(ads, directory, filename):
    """Funkcija vse podatke iz parametra "ads" zapiše v csv datoteko, podano s
    parametroma "directory"/"filename". Funkcija predpostavi, da sa ključi vseh
    slovarjev parametra ads enaki in je seznam ads neprazen.

    """
    # Stavek assert preveri, da zahteva velja
    # Če drži se program normalno izvaja, drugače pa sproži napako
    # Prednost je v tem, da ga lahko pod določenimi pogoji izklopimo v
    # produkcijskem okolju
    assert ads and (all(j.keys() == ads[0].keys() for j in ads))
    write_csv(ads[0].keys(), ads, directory, filename)

# Tole poženem, da s enardei csv:
# write_cat_ads_to_csv(ads_frontpage(), cat_directory, csv_filename)


# Celoten program poženemo v glavni funkciji (jaz sem to postopoma
# naredila že pri vsakem sklopu posebej.)


def main(redownload=True, reparse=True):
    """Funkcija izvede celoten del pridobivanja podatkov:
    1. Oglase prenese iz bolhe
    2. Lokalno html datoteko pretvori v lepšo predstavitev podatkov
    3. Podatke shrani v csv datoteko
    """
    # Najprej v lokalno datoteko shranimo glavno stran
    save_frontpage(cat_directory, frontpage_filename)
    # Iz lokalne (html) datoteke preberemo podatke
    ads = page_to_ads(read_file_to_string(cat_directory, frontpage_filename))
    # Podatke prebermo v lepšo obliko (seznam slovarjev)
    ads_nice = [get_dict_from_ad_block(ad) for ad in ads]
    # Podatke shranimo v csv datoteko
    write_cat_ads_to_csv(ads_nice, cat_directory, csv_filename)

    # Dodatno: S pomočjo parameteov funkcije main omogoči nadzor, ali se
    # celotna spletna stran ob vsakem zagon prense (četudi že obstaja)
    # in enako za pretvorbo

    raise NotImplementedError()


#if __name__ == '__main__':
#    main()
