#!/bin/bash
readonly PROJECT_ID=${1}
readonly provider="google-v2"
readonly logging=${2}
readonly machine_type=${3}
readonly disk_size=${4}
readonly boot_size=${5}
readonly script=${6}
#readonly batch=${7}
readonly circrna_db=${7}
readonly DOCKER="quay.io/biocontainers/bedtools:2.27.0--he860b03_3"

#grep -v "^--" $batch | while read LINE
while read -r line
do
  echo $line
  sample_id=$(echo $line|awk -F"," '{print $1}')
  out_prefix=$(echo $line|awk -F","  '{print $3}')
  circgenes=${out_prefix}/starchip/circRNA.5reads.1ind.genes
  if [[ ! `gsutil ls  ${out_prefix}/starchip/circRNA.5reads.1ind.genes.overlap.*.bed` ]];then 
  cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --provider "${provider}" \
    --logging ${logging} \
    --disk-size ${disk_size} \
    --boot-disk-size ${boot_size} \
    --machine-type ${machine_type} \
    --image ${DOCKER} \
    --input-recursive CIRCRNA_DB=${circrna_db} \
    --input CIRCRNA_GENES=${circgenes} \
    --output  OUTPUTS=${circgenes}.overlap.*.bed \
    --script ${script} \
    --preemptible "
echo $cmd
$cmd
fi
done

