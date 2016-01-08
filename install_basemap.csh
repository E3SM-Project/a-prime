#!/bin/csh

wget http://sourceforge.net/projects/matplotlib/files/matplotlib-toolkits/basemap-1.0.7/basemap-1.0.7.tar.gz 

mv basemap-1.0.7.tar.gz $HOME
cd $HOME

tar -xzf basemap-1.0.7.tar.gz

cd basemap-1.0.7

cd geos-3.3.3

setenv GEOS_DIR ~/geos-3.3.3

./configure --prefix=$GEOS_DIR

make; make install

cd ..

module unload PE-intel
module load PE-gnu

module load python
module load python_numpy
module load python_matplotlib

python setup.py install --user

cd examples

python simpletest.py


