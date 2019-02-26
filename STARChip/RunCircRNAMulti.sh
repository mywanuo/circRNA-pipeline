#!/bin/bash

#reference
/opt/starchip/setup.sh ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf ${STAR_CHIP_REF}/GRCh38.primary_assembly.genome.fa ${STAR_CHIP_REF}/
ls ${STAR_CHIP_REF}

cd ${OUTPUT_DIR}
#write star_dir.txt
touch star_dir.txt
STAR_DIR=$(dirname ${STAR_DIR_1})
samples=`ls ${STAR_DIR}`
for s in ${samples};do
        echo ${STAR_DIR}/${s} >>star_dir.txt
done


cp ${STAR_CHIP_REF}/params.txt ./params.txt
echo "refbed = ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf.exons.bed " >>./params.txt
echo "refFasta = ${STAR_CHIP_REF}/GRCh38.primary_assembly.genome.fa" >>./params.txt
echo "cpus = 16" >>./params.txt
echo "starprefix =   ${SMTAG}." >>params.txt
echo  "IDstepsback = 1 " >> ./params.txt
echo "runSTAR = false" >> ./params.txt
echo "STARreadcommand = zcat " >>./params.txt
echo "starprefix =  " >> ./params.txt


cat star_dir.txt
cat params.txt

ls 
#run starchip
/opt/starchip/starchip-circles.pl star_dir.txt params.txt
./Step1.sh && ./Step2.sh

