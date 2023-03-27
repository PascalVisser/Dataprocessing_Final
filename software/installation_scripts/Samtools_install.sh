 #!bin/sh
#Samtools 1.11
wget -O samtools.tar.bz2 https://sourceforge.net/projects/samtools/files/samtools/1.11/samtools-1.11.tar.bz2/download
tar -xf samtools.tar.bz2 -C software
export PATH=$PATH:Dataprocessing_eindopdracht/software/samtools-0.1.11
rm samtools.tar.bz2