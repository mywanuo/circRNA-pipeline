#!/bin/bash
readonly PROJECT_ID=${1}
readonly provider="google-v2"
readonly logging=${2}
readonly machine_type=${3}
readonly disk_size=${4}
readonly boot_size=${5}
readonly script=${6}
readonly starchip_ref=${7}
readonly star_dir=${8}
readonly outdir=${9}
readonly DOCKER="quay.io/xujishu/star-circrna:0.0.1"

i=0
#samples=`gsutil ls ${star_dir}|tail -n 70`
#echo $samples
cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --provider "${provider}" \
    --logging ${logging} \
    --disk-size ${disk_size} \
    --boot-disk-size ${boot_size} \
    --machine-type ${machine_type} \
    --image ${DOCKER} \
    --input-recursive STAR_CHIP_REF=${starchip_ref} \
     --output-recursive OUTPUT_DIR=${outdir} \
    --script ${script} \
    --preemptible " 

#for f in $samples;do
while read -r line
do
  f=$line
  i=$(( $i + 1 ))
  cmd=$cmd" --input-recursive STAR_DIR_${i}=${f} "  

done
echo $cmd
