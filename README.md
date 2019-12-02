# WRFHydro
# Setup on CloudLab
## Step 0: Increase space
sudo apt-get update;  <br/> 
sudo apt install udisks2;  <br/>
df -h;  <br/>
lsblk;  <br/>
sudo mkdir /mnt/big; <br/>
mkfs.ext4 /dev/sda4; <br/>
sudo mount -t auto -v /dev/sda4 /mnt/big; <br/>
TO UNMOUNT: sudo umount /dev/sda4 -l; <br/>
cd /mnt/big;<br/>
sudo apt-get install tmux; <br/>
sudo apt-get install htop; <br/>

## STEP1a: IF NOT DOWNLOADED: Download hydro,wrf,rainfall, domaincases:
hydro,wrf,rainfall, domaincases:<br/>
scp -r ~/ResearchZink/WRF/*.gz -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;<br/>
scp -r ~/ResearchZink/WRF/diff_res-20190712T063837Z-001.zip -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;<br/>
scp -r ~/ResearchZink/WRF/wrkdir_rt125_forIshita_2017Jan.zip -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:; <br/>
 
OR <br/>
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/WRF_Hydro3.0.tar.gz; <br/>
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/WRF_hydro_DFW_setup.tar.gz; <br/>
wget -L https://drive.google.com/drive/folders/1gVEMWSzfpedXBaV-TUhwfQH1bYSu9bnJ; <br/>
wget -L https://drive.google.com/open?id=1Z0PiT8dRzrk8WLv6q5PA6LavE9Aq5R6d; <br/>
wget -L https://drive.google.com/drive/folders/1gVEMWSzfpedXBaV-TUhwfQH1bYSu9bnJ?usp=sharing <br/>
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/netcdf-3.6.3-beta1.tar.gz; <br/>
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/mpich-3.2.1.tar.gz;<br/>

wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1lyNo-qH6oqOh3YL8h76nwz3zEvXxfRVo" -O diff_res-20190712T063837Z-001.zip && rm -rf /tmp/cookies.txt;<br/>
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O- | sed -rn 's/.confirm=([0-9A-Za-z_]+)./\1\n/p')&id=1F2FEl-uob5XAvE5DU_u3TkFGw61iKQod" -O c4_1.tar.gz && rm -rf /tmp/cookies.txt;<br/>
## STEP1b: IF DOWNLOADED in proj directory:
cp -r /proj/wrfhydro-PG0/big/* .;

## STEP2: Install dependencies
### NETCDF
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/netcdf-3.6.3-beta1.tar.gz;<br/>
sudo apt-get update; sudo apt-get install -y gfortran; <br/>
sudo apt-get install -y tmux;sudo apt-get install -y vim;<br/>
sudo apt-get install -y libboost-all-dev;<br/>
export FC=gfortran;<br/>
sudo mkdir /opt/netcdf; sudo mkdir /opt/netcdf/3.6.3;<br/>
cd netcdf-3.6.3-beta1; ./configure --prefix=/opt/netcdf/3.6.3; make; sudo make install;<br/>
export NETCDFHOME=/opt/netcdf/3.6.3; export NETCDFINC=/opt/netcdf/3.6.3/include; export NETCDFLIB=/opt/netcdf/3.6.3/lib;<br/>
### OPENMPI
mkdir openmi
cd openmi/
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz
tar -xvzf openmpi-4.0.2.tar.gz
cd openmpi-4.0.2/
./configure --prefix=/mnt/big/openmi

 
### MPICH
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/mpich-3.2.1.tar.gz;<br/>
sudo apt-get install libswitch-perl; sudo apt-get install m4;<br/>



## Step 3: compile WRF
cd ../hydro<br/>
csh;<br/>
setenv WRF_HYDRO 1; setenv NETCDF "/opt/netcdf/3.6.3"; setenv NETCDF_INC "/opt/netcdf/3.6.3/include";setenv NETCDF_LIB "/opt/netcdf/3.6.3/lib"<br/>
./configure  (5: Linux gfort sequential compiler/6: for parallel)<br/>
vim macros #Remove -C from line 40 CPPFLAGS =<br/>
./compile_offline_NoahMP.csh<br/>
//creates wrf_hydro.exe -> wrf_hydro_Noah.exe in Run/ directory<br/>

## Step 4: Run WRF
##For sunghee's new data:<br/>
cd /mnt/big/wrkdir_rt125_forIshita_2017Jan;<br/>
cp /mnt/big/hydro/Run/wrf_hydro_NoahMP.exe wrf_hydro_NoahMP.exe;<br/>

#latest case
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist;<br/>
cp -r ../c4_1_rt100m_acc2_test_runtime_10processors_lfor_Ishita/* .; <br/>

#Cases: 100m
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist; <br/>
cp -r ../diff_res/c4_1_rt100m_acc2/* .<br/>

rm *_DOMAIN1;<br/>
time mpiexec -np 16 ./wrf_hydro_NoahMP.exe<br/>

#Cases: 50m
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist;<br/>
cp -r ../diff_res/c4_2_rt50m_acc8/* .<br/>
rm *_DOMAIN1;<br/>
time mpiexec -np 4 ./wrf_hydro_NoahMP.exe<br/>

#Cases: 25m<br/>
rm -rf DOMAIN; rm namelist.hrldas; rm hydro.namelist;<br/>
cp -r ../diff_res/c4_3_rt25m_acc32/* .<br/>

rm -rf *LDASOUT*; rm *_DOMAIN1;<br/>
time mpiexec -np 4 ./wrf_hydro_NoahMP.exe<br/>

#after run<br/>
rm *_DOMAIN1;<br/>

## Other details
cp Run/wrf_hydro_NoahMP.exe ../WRF_hydro_DFW_setup/wrfMP.exe<br/>
cd ../WRF_hydro_DFW_setup<br/>
time mpiexec -np 4 ./wrf_hydro_NoahMP.exe <br/>

##if we get libmpi.so.12 error do this<br/>
check if libmpi.so.12 is present in /usr/local/lib<br/>
if yes, modify LD_LIBRARY_PATH, set it to:<br/>
export LD_LIBRARY_PATH=/usr/local/lib<br/>
sudo lsdconfig<br/>
#NOW RUN! IT SHOULD RUN!<br/>
_________________________________________________________________
### MPI ON 2 NODES<br/>

cat /etc/hosts and find out the name for other nodes in the cluster. <br/>
	127.0.0.1       localhost loghost localhost.wrf.wrfhydro-pg0.wisc.cloudlab.us<br/>
	10.10.1.1       wrf2-link-0 wrf2-0 wrf2 (other node)<br/>
	10.10.1.2       wrf1-link-0 wrf1-0 wrf1<br/>
sudo apt-get install openssh-server<br/>

eval `ssh-agent`<br/>
ssh-add ~/.ssh/id_rsa<br/>
@wrf1: ssh wrf2 (should log in)<br/>
@wrf2: ssh wrf1<br/>

Now: Setting up NFS server at wrf1 node<br/>
sudo apt-get install -y nfs-kernel-server<br/>
cat /etc/exports<br/>
/mnt/big/wrkdir_rt125_forIshita_2017Jan *(rw,sync,no_root_squash,no_subtree_check)
exportfs -a (Run this eveyrtime any change is made to /etc/exports)
sudo service nfs-kernel-server restart (to restart nfs server)<br/>

NFS Client at wrf2 node:<br/>
sudo mount -t nfs wrf1:/mnt/big/wrkdir_rt125_forIshita_2017Jan /users/ishitadg/<br/>

To see mounted dirs: df -h <br/>
We see: wrf1:/mnt/big/wrkdir_rt125_forIshita_2017Jan  1.1T  5.1G 1019G   1% /users/ishitadg<br/>

Permanent mount: vim /etc/fstab<br/>
wrf1:/users/ishitadg/wrkdir_rt125_forIshita_2017Jan /users/ishitadg/wrkdir_rt125_forIshita_2017Jan nfs<br/>

Now run mpi: <br/>
cd /mnt/big/mpich-3.2.1/examples/;<br/>
mpicc -o srtest srtest.c;<br/>
cp srtest ../../wrkdir_rt125_forIshita_2017Jan/;<br/>
cd ../../wrkdir_rt125_forIshita_2017Jan/;<br/>

mpirun -np 4 -hosts wrf2,wrf1 ./srtest <br/>
_________________________________________________________________<br/>
Similarly we do <br/>

time mpiexec -np 4 -hosts wrf2,wrf1 ./wrf_hydro_NoahMP.exe<br/>

