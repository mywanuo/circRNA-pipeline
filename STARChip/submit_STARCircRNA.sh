#!/bin/bash
readonly PROJECT_ID=${1}
readonly provider="google-v2"
readonly logging=${2}
readonly machine_type=${3}
readonly disk_size=${4}
readonly boot_size=${5}
readonly script=${6}
#readonly batch=${7}
readonly star_ref=${7}
readonly starchip_ref=${8}
readonly DOCKER="quay.io/xujishu/star-circrna:0.0.1"

#grep -v "^--" $batch | while read LINE
while read -r line
do
  echo $line
  sample_id=$(echo $line|awk -F"," '{print $1}')
  fastqdir=$(echo $line|awk -F","  '{print $2}')
  out_prefix=$(echo $line|awk -F","  '{print $3}')
  prjid=$(echo $line|awk -F","  '{print $4}')
  #fq1=$fastqdir"_R1_001.fastq.gz"
  #fq2=$fastqdir"_R2_001.fastq.gz"
  fq1=$fastqdir"_R1.fastq.gz"
  fq2=$fastqdir"_R2.fastq.gz"
baifile=${out_prefix}/${prjid}.Aligned.sortedByCoord.out.bam.bai
 echo $baifile 
 if [[ ! `gsutil ls  ${baifile}` ]];then
cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --provider "${provider}" \
    --logging ${logging} \
    --disk-size ${disk_size} \
    --boot-disk-size ${boot_size} \
    --machine-type ${machine_type} \
    --image ${DOCKER} \
    --input FASTQ1=${fq1} \
    --input FASTQ2=${fq2} \
    --input STAR_REF=${star_ref} \
    --input-recursive STAR_CHIP_REF=${starchip_ref} \
    --env RGID=${prjid} \
    --env SMTAG=${prjid} \
    --output-recursive OUTPUT_DIR="${out_prefix}" \
    --script ${script} \
    --preemptible "

echo $cmd
$cmd
fi
done

