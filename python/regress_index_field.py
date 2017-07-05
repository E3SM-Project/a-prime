from scipy import stats
import numpy

def regress_index_field(index, field):
	nlon = field.shape[2]
	nlat = field.shape[1]
	ntime = field.shape[0]

	regr_matrix   = numpy.zeros((nlat, nlon)) + numpy.nan
	const_matrix  = numpy.zeros((nlat, nlon)) + numpy.nan
	corr_matrix   = numpy.zeros((nlat, nlon)) + numpy.nan
	p_val_matrix  = numpy.zeros((nlat, nlon)) + numpy.nan
	t_test_matrix = numpy.zeros((nlat, nlon)) 
	stderr_matrix = numpy.zeros((nlat, nlon)) + numpy.nan

	for i in range(0, nlon):
		for j in range (0, nlat):
			regr_matrix[j, i], const_matrix[j, i], corr_matrix[j, i], \
			p_val_matrix[j, i], stderr_matrix[j, i] = stats.linregress(index, field[:, j, i])
	
		
	t_test_matrix[numpy.where(p_val_matrix < 0.05)] = 1 

	return regr_matrix, const_matrix, corr_matrix, t_test_matrix, stderr_matrix


