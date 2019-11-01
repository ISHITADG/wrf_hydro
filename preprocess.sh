#!/bin/sh
################################## S E T U P ############################################

##scp all required 
scp -r ~/ResearchZink/WRF/*.gz -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;
scp -r ~/ResearchZink/WRF/diff_res-20190712T063837Z-001.zip -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;
scp -r ~/ResearchZink/WRF/wrkdir_rt125_forIshita_2017Jan.zip -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;

##untar everything
mv *  /mnt/big/
cd /mnt/big

gunzip -c netcdf-3.6.3-beta1.tar.gz | tar xopf - ;gunzip -c WRF_hydro_DFW_setup.tar.gz | tar xopf - ;gunzip -c WRF_Hydro3.0.tar.gz | tar xopf - ;
gunzip -c mpi*.gz | tar xopf -;

unzip diff_res-20190712T063837Z-001.zip; unzip wrkdir_rt125_forIshita_2017Jan.zip;
rm *.gz; rm *.zip;


##install netcdf
sudo apt-get update; sudo apt-get install -y gfortran; 
sudo apt-get install -y tmux;sudo apt-get install -y vim;
sudo apt-get install -y libboost-all-dev;
 

export FC=gfortran;
sudo mkdir /opt/netcdf; sudo mkdir /opt/netcdf/3.6.3;
cd netcdf-3.6.3-beta1; ./configure --prefix=/opt/netcdf/3.6.3; make; sudo make install;
export NETCDFHOME=/opt/netcdf/3.6.3; export NETCDFINC=/opt/netcdf/3.6.3/include; export NETCDFLIB=/opt/netcdf/3.6.3/lib;
#other installations
sudo apt-get install libswitch-perl; sudo apt-get install m4;
#sudo apt-get install mpich;
#sudo apt-get install libcr-dev mpich2 mpich2-doc

##MPI installation
cd ../mpich-3.2.1;
./configure;
make; 
sudo make install;
check with mpiexec --version (runs with mpirun too). While running an application, run it as ./app

##WRF-installation
cd ../hydro
csh;
setenv WRF_HYDRO 1; setenv NETCDF "/opt/netcdf/3.6.3"; setenv NETCDF_INC "/opt/netcdf/3.6.3/include";setenv NETCDF_LIB "/opt/netcdf/3.6.3/lib"
./configure  (5: Linux gfort sequential compiler)
vim macros #Remove -C from line 40 CPPFLAGS =
./compile_offline_NoahMP.csh
#creates wrf_hydro.exe -> wrf_hydro_Noah.exe in Run/ directory


################################## R U N ############################################
##For sunghee's new data:
cd /mnt/big/wrkdir_rt125_forIshita_2017Jan;
cp /mnt/big/hydro/Run/wrf_hydro_NoahMP.exe wrf_hydro_NoahMP.exe;

#latest case
#rm CHANPARM.TBL DISTR_HYDRO_CAL_PARMS.TBL GENPARM.TBL GWBUCKPARM.TBL hydro.namelist HYDRO.TBL LAKEPARM.TBL MPTABLE.TBL namelist.hrldas SOILPARM.TBL URBPARM.TBL VEGPARM.TBL;
#rm -rf Run_3scalingfac_write_infxsrt/; rm -rf DOMAIN;
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist;
cp -r ../c4_1_rt100m_acc2_test_runtime_10processors_for_Ishita/* .; 

#Cases: 100m
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist; 
cp -r ../diff_res/c4_1_rt100m_acc2/* .

rm *_DOMAIN1;
time mpiexec -np 16 ./wrf_hydro_NoahMP.exe

#Cases: 50m
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist;
cp -r ../diff_res/c4_2_rt50m_acc8/* .
rm *_DOMAIN1;
time mpiexec -np 4 ./wrf_hydro_NoahMP.exe

#Cases: 25m
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist;
cp -r ../diff_res/c4_3_rt25m_acc32/* .

rm -rf *LDASOUT*; rm *_DOMAIN1;
time mpiexec -np 4 ./wrf_hydro_NoahMP.exe

#after run
rm *_DOMAIN1;


_________________________________________________________________
cp Run/wrf_hydro_NoahMP.exe ../WRF_hydro_DFW_setup/wrfMP.exe
cd ../WRF_hydro_DFW_setup
time mpiexec -np 4 ./wrf_hydro_NoahMP.exe

##if we get libmpi.so.12 error do this
check if libmpi.so.12 is present in /usr/local/lib
if yes, modify LD_LIBRARY_PATH, set it to:
export LD_LIBRARY_PATH=/usr/local/lib
sudo lsdconfig
#NOW RUN! IT SHOULD RUN!
_________________________________________________________________
MPI ON 2 NODES

cat /etc/hosts and find out the name for other nodes in the cluster. 
	127.0.0.1       localhost loghost localhost.wrf.wrfhydro-pg0.wisc.cloudlab.us
	10.10.1.1       wrf2-link-0 wrf2-0 wrf2 (other node)
	10.10.1.2       wrf1-link-0 wrf1-0 wrf1
sudo apt-get install openssh-server

eval `ssh-agent`
ssh-add ~/.ssh/id_rsa
@wrf1
ssh wrf2 (should log in)
@wrf2
ssh wrf1

Now: Setting up NFS server at wrf1 node
sudo apt-get install -y nfs-kernel-server
cat /etc/exports
/mnt/big/wrkdir_rt125_forIshita_2017Jan *(rw,sync,no_root_squash,no_subtree_check)
exportfs -a (Run this eveyrtime any change is made to /etc/exports)
sudo service nfs-kernel-server restart (to restart nfs server)

NFS Client at wrf2 node:
sudo mount -t nfs wrf1:/mnt/big/wrkdir_rt125_forIshita_2017Jan /users/ishitadg/

To see mounted dirs: df -h 
We see: wrf1:/mnt/big/wrkdir_rt125_forIshita_2017Jan  1.1T  5.1G 1019G   1% /users/ishitadg

Permanent mount: vim /etc/fstab
wrf1:/users/ishitadg/wrkdir_rt125_forIshita_2017Jan /users/ishitadg/wrkdir_rt125_forIshita_2017Jan nfs

Now run mpi: 
cd /mnt/big/mpich-3.2.1/examples/;
mpicc -o srtest srtest.c;
cp srtest ../../wrkdir_rt125_forIshita_2017Jan/;
cd ../../wrkdir_rt125_forIshita_2017Jan/;

mpirun -np 4 -hosts wrf2,wrf1 ./srtest 
_________________________________________________________________
Similarly we do 

time mpiexec -np 4 -hosts wrf2,wrf1 ./wrf_hydro_NoahMP.exe
_________________________________________________________________________________________________
****PARTITION***********
apt-get update 
apt install udisks2
df -h
lsblk


lsblk -o NAME,FSTYPE,LABEL,SIZE,MOUNTPOINT

sudo mkdir /mnt/big
mkfs.ext4 /dev/sda4
sudo mount -t auto -v /dev/sda4 /mnt/big

TO UNMOUNT: sudo umount /dev/sda4 -l


Also, when I try to run the mobius client on my MAC (Its running Mojave OS), I get JSONDecodeError. Could you help me with that? All I did was get docker and docker compose installed. 
I tried running mobius client with both python 2.7 and 3 with same error. I edited the docker-compose.yml and 
