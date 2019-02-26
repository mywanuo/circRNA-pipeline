#!/bin/bash

# reference
STAR_DIR=$(dirname ${CHIMERA_TAB})
ls ${STAR_DIR}

/opt/starchip/setup.sh ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf ${STAR_CHIP_REF}/GRCh38.primary_assembly.genome.fa ${STAR_CHIP_REF}/
ls ${STAR_CHIP_REF}
cd ${OUTPUT_DIR}

cp ${STAR_CHIP_REF}/params.txt ./params.txt
echo "refbed = ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf.exons.bed " >>./params.txt
echo "refFasta = ${STAR_CHIP_REF}/GRCh38.primary_assembly.genome.fa" >>./params.txt
echo "cpus = 2" >>./params.txt
echo "starprefix =   ${SMTAG}." >>params.txt
echo  "IDstepsback = 1 " >> ./params.txt
echo "runSTAR = false" >> ./params.txt
echo "STARreadcommand = zcat " >>./params.txt
echo  "IDstepsback = 1" >>./params.txt
echo "starprefix =  ${SMTAG}. " >> ./params.txt

echo ${STAR_DIR} > star_dir.txt

cat star_dir.txt
cat params.txt

ls 
#run starchip
/opt/starchip/starchip-circles.pl star_dir.txt params.txt
./Step1.sh && ./Step2.sh
rm Step1.sh Step2.sh params.txt star_dir.txt

