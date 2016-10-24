import math

def round_to_first(x):
	if x != 0:
		return round(x, -int(math.floor(math.log10(abs(x)))))
	else:
		return 0

