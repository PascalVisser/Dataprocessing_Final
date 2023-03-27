 #!bin/sh
#bedtools
wget -O bedtools-2.29.1.tar.gz https://github.com/arq5x/bedtools2/releases/download/v2.29.1/bedtools-2.29.1.tar.gz
tar -zxvf bedtools-2.29.1.tar.gz -C software
cd software/bedtools2
make
rm bedtools-2.29.1.tar.gz