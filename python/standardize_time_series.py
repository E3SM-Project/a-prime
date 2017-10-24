import numpy

def standardize_time_series(field):

	field_stddize = (field - field.mean(axis = 0))/field.std(axis = 0)

        return field_stddize

if __name__ == "__main__":
        standardize_time_series(field)
