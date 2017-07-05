# to compute mean (aggregates) of time series data at different intervals,
# for e.g. to compute annual mean from daily timeseries data.

import numpy

def aggregate_time_series_data(data, aggregate_size, wgts):
    nx = data.shape[2]
    ny = data.shape[1]
    nt = data.shape[0]

    n_aggregates = nt/aggregate_size

    aggregate_data = numpy.ma.zeros((n_aggregates, ny, nx))

    for i in range(0, n_aggregates):
        aggregate_data[i, :, :] = numpy.average(data[i*aggregate_size:(i+1) * aggregate_size, :, :], axis = 0, weights = wgts)

    print "aggregate_data.shape: ", aggregate_data.shape

    return aggregate_data
