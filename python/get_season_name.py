from get_season_months_index import get_season_months_index

def get_season_name(begin_month, end_month):


	initials = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D']

	month_index, n_months = get_season_months_index(begin_month, end_month)
	
	season_name = ''

	for i in month_index:
		season_name = season_name + initials[i]

	if begin_month == 0 and end_month == 11: 
		season_name = 'ANN'

	print 'season_name: ', season_name
	return season_name
