#!/bin/bash
readonly PROJECT_ID=${1}
readonly logging=${2}
readonly machine_type=${3}
readonly script=${4}
readonly tab_name=${5}
readonly output_file=${6}
readonly provider="google-v2"
readonly DOCKER="quay.io/biocontainers/pandas:0.23.4--py36hf8a1672_0"

i=0
#samples=`gsutil ls ${star_dir}|tail -n 70`
#echo $samples
cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --provider "${provider}" \
    --logging ${logging} \
    --disk-size 200 \
    --machine-type ${machine_type} \
    --image ${DOCKER} \
    --output  OUTPUT_FILE=${output_file} \
    --env TAB_NAME=${tab_name} \
    --script ${script} \
    --preemptible "

#for f in $samples;do
while read -r line
do
  out_prefix=$(echo $line|awk -F","  '{print $3}')
  circgenes=${out_prefix}/starchip/circRNA.5reads.1ind.${tab_name}
  i=$(( $i + 1 ))
  cmd=$cmd" --input  INPUT_FILE_${i}=${circgenes} "
done
echo $cmd
$cmd
