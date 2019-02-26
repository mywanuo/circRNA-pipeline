#!/bin/bash
tar -xf $STAR_REF
ls ./star/
## run star alignment
STAR --genomeDir ./star/ \
        --readFilesIn "${FASTQ1}" "${FASTQ2}" \
        --runThreadN 16 \
        --outReadsUnmapped Fastx \
        --outSAMunmapped Within \
        --quantMode GeneCounts \
        --chimSegmentMin 15  \
        --chimJunctionOverhangMin 15 \
        --outSAMtype BAM SortedByCoordinate \
        --genomeLoad NoSharedMemory \
        --sjdbGTFfile ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf \
        --readFilesCommand zcat \
        --chimOutType Junctions SeparateSAMold \
        --outFileNamePrefix "${OUTPUT_DIR}/${SMTAG}." \
        --outSAMattrRGline "ID:${RGID}" "SM:${RGID}" "PL:illumina" "PU:${RGID}"

samtools index ${OUTPUT_DIR}/${SMTAG}.Aligned.sortedByCoord.out.bam

ls ${OUTPUT_DIR}
# reference
/opt/starchip/setup.sh ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf ${STAR_CHIP_REF}/GRCh38.primary_assembly.genome.fa ${STAR_CHIP_REF}/
ls ${STAR_CHIP_REF}
mkdir ${OUTPUT_DIR}/starchip
cd ${OUTPUT_DIR}/starchip
cp ${STAR_CHIP_REF}/params.txt ./params.txt
ls
echo "refbed = ${STAR_CHIP_REF}/gencode.v27.primary_assembly.annotation.gtf.exons.bed " >>./params.txt
echo "refFasta = ${STAR_CHIP_REF}/GRCh38.primary_assembly.genome.fa" >>./params.txt
echo "cpus = 12" >>./params.txt
echo "starprefix =   ${SMTAG}." >>params.txt
echo  "IDstepsback = 1 " >> ./params.txt
echo "runSTAR = false" >> ./params.txt
echo "STARreadcommand = zcat " >>./params.txt
echo  "IDstepsback = 1" >>./params.txt
echo "starprefix =  ${SMTAG}. " >> ./params.txt

echo ${OUTPUT_DIR} > star_dir.txt

#cat star_dir.txt
#cat params.txt

ls
#run starchip
/opt/starchip/starchip-circles.pl star_dir.txt params.txt
./Step1.sh && ./Step2.sh
# clean up
rm -rf ${OUTPUT_DIR}/${SMTAG}._STARgenome
rm ./Step1.sh ./Step2.sh
rm ./params.txt ./star_dir.txt

