#
# Copyright (c) 2017, UT-BATTELLE, LLC
# All rights reserved.
# 
# This software is released under the BSD license detailed
# in the LICENSE file in the top level a-prime directory
#
import numpy
from sympy import *

def get_derived_var_expr (field_name):


	if field_name == 'PRECT':
		PRECC, PRECL = symbols('PRECC, PRECL')
		var_expr = PRECC + PRECL
	elif field_name == 'RESTOM':
		FSNT, FLNT = symbols('FSNT, FLNT')
		var_expr = FSNT - FLNT
	else:
		print
		print 'No derived variable list found for ', field_name

	print
	print field_name, 'derived from: ', var_expr.atoms(Symbol)

	var_expr_numpy = lambdify(var_expr.atoms(Symbol), var_expr, "numpy")

	return var_expr, var_expr_numpy


