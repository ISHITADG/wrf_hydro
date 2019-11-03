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
###netcdf
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/netcdf-3.6.3-beta1.tar.gz;
###mpich
wget -L https://github.com/ISHITADG/wrf_hydro/raw/master/mpich-3.2.1.tar.gz;

hydro,wrf,rainfall, domaincases:
scp -r ~/ResearchZink/WRF/*.gz -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;
scp -r ~/ResearchZink/WRF/diff_res-20190712T063837Z-001.zip -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:;
scp -r ~/ResearchZink/WRF/wrkdir_rt125_forIshita_2017Jan.zip -p 22 ishitadg@c220g1-031125.wisc.cloudlab.us:; <br/>
bash 1_ndn.sh <br/>
### Additional step at server: (install vim,tmux,BB video files,apache2)
wget -L https://raw.githubusercontent.com/ISHITADG/NDN---in-parallel-SDN-and-NFV/master/1_server.sh <br/>
bash 1_server.sh <br/>
*OR* <br/>
wget -L https://raw.githubusercontent.com/ISHITADG/NDN---in-parallel-SDN-and-NFV/master/1_serverdld.sh <br/>
bash 1_serverdld.sh <br/>
### Additional step at client: (run Dockerfile, download client, Astreamer)
#### DOCKER - KERNEL VERSION ISSUE (ONLY FOR NDN CLIENT):
