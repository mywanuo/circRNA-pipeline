#!/bin/bash
readonly PROJECT_ID=${1}
readonly provider="google-v2"
readonly logging=${2}
readonly machine_type=${3}
readonly disk_size=${4}
readonly boot_size=${5}
readonly script=${6}
readonly batch=${7}
readonly starchip_ref=${8}
readonly DOCKER="quay.io/xujishu/star-circrna:0.0.1"

grep -v "^--" $batch | while read LINE
do
  sample_id=$(echo $LINE|awk '{print $1}')
  out_prefix=$(echo $LINE|awk '{print $3}')
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
    --input  CHIMERA_FILES=${out_prefix}/${sample_id}.Chimeric* \
    --input  CHIMERA_TAB=${out_prefix}/${sample_id}.SJ.out.tab \
    --env SMTAG=${sample_id} \
    --output-recursive OUTPUT_DIR="${out_prefix}/starchip" \
    --script ${script} \
    --preemptible "

echo $cmd
done
