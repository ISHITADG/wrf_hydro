#!/bin/sh

# REPLACING WITH COMPATIBLE GCC/GFORT VERSIONS and other dependencies required
sudo apt-get install gcc-4.4;
sudo rm /usr/bin/gcc;
sudo ln -s /usr/bin/gcc-4.4 /usr/bin/gcc;

sudo apt-get install gfortran-4.4;
sudo rm /usr/bin/gfortran;
sudo ln -s /usr/bin/gfortran-4.4 /usr/bin/gfortran;

sudo apt-get install make;
sudo apt-get install m4;
sudo apt-get install g++ #makes sure you have cpp for HDF5
# **************CURL/LIBCURL***************
cd ~
# Install CURL
cd
tar -xvzf curl-7.53.1.tar.gz
cd curl-7.53.1
# Build curl
make;
make check;
sudo make install;   # or sudo make install, if root permissions required
# **************ZLIB***************
cd ~
# Install ZLIB
wget http://www.zlib.net/zlib-1.2.11.tar.gz
tar -xvzf zlib-1.2.11.tar.gz
cd zlib-1.2.11
# Build and install zlib
ZDIR=/usr/local;
./configure --prefix=${ZDIR};
make;
make check;
sudo make install;   # or sudo make install, if root permissions required
# ***********HDF5******************
cd~
#Install HDF5
wget https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.18.tar.gz
tar -xvzf hdf5-1.8.18.tar.gz
cd hdf5-1.8.18
# Build and install HDF5
H5DIR=/usr/local
./configure --with-zlib=${ZDIR} --prefix=${H5DIR}
make
make check
sudo make install   # or sudo make install, if root permissions required
# ***********NETCDF****************
cd ~
#Install NETCDF
wget https://www.gfd-dennou.org/arch/ucar/netcdf/netcdf-4.4.1.tar.gz
tar -xvzf netcdf-4.4.1.tar.gz
cd netcdf-4.4.1
NCDIR=/usr/local
CPPFLAGS=-I${H5DIR}/include LDFLAGS=-L${H5DIR}/lib ./configure --prefix=${NCDIR} --disable-doxygen
make
make check #Some of the Tests may fail if curl is not installed first
sudo make install   # or sudo make install, if root permissions required

# ***********SETUP_WRF_HYDRO*************
cd ~/hydro

echo "export NETCDF=/usr/local" >> ~/.bashrc; 
echo "export NETCDF_INC=/usr/local/include" >> ~/.bashrc; 
echo "export NETCDF_LIB=/usr/local/lib" >> ~/.bashrc; 
source ~/.bashrc;

#Removing all gz files
rm ~/*tar.gz ;
