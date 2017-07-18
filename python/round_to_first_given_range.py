import math

def round_to_first_given_range(x, range_x):
	if x != 0:
		return round(x, -int(math.floor(math.log10(abs(range_x)))))
	else:
		return 0

