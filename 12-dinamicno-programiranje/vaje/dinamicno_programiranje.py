# ========== Vaje 6: Dinamično programiranje  ==========

#----------------------------------------------------------------------------*]
# Požrešna miška se nahaja v zgornjem levem kotu šahovnice. Premikati se sme
# samo za eno polje navzdol ali za eno polje na desno in na koncu mora prispeti
# v desni spodnji kot. Na vsakem polju šahovnice je en sirček. Ti sirčki imajo
# različne (ne-negativne) mase. Miška bi se rada kar se da nažrla, zato jo
# zanima, katero pot naj ubere.

# Funkcija [max_cheese cheese_matrix], ki dobi matriko [cheese_matrix] z masami
# sirčkov in vrne največjo skupno maso, ki jo bo miška požrla, če gre po
# optimalni poti.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # max_cheese test_matrix;;
# - : int = 13
#[*----------------------------------------------------------------------------*)

test_matrix = [[ 1 , 2 , 0 ], [ 2 , 4 , 5 ], [ 7 , 0 , 1 ]]


def max_cheese(cheese_matrix):
	max_i = len(cheese_matrix) 
	max_j = len(cheese_matrix[0])
	max_matrix = [[0 for j in range(max_j)] for i in range(max_i)]
	
	def how_much_cheese(i, j):
		cheese = cheese_matrix[i][j]
		max_right = max_matrix[i][j+1] if j < (max_j-1) else 0
		max_down = max_matrix[i+1][j] if i < (max_i-1) else 0
		return cheese + max(max_right, max_down)

	def loop(i, j):
		cheese = how_much_cheese(i, j)
		max_matrix[i][j] = cheese
		if j > 0:
			return loop(i, j-1)
		elif i > 0: 
			return loop(i-1, max_j-1)
		else:
			  return
	loop (max_i-1, max_j-1)
	return max_matrix[0][0]
