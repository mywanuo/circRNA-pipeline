#!/bin/bash
readonly PROJECT_ID=${1}
readonly provider="google-v2"
readonly logging=${2}
readonly machine_type=${3}
#readonly disk_size=${4}
#readonly boot_size=${5}
readonly script=${4}
readonly starchip_ref=${5}
readonly DOCKER="quay.io/xujishu/star-circrna:0.0.1"

while read -r LINE
do
  sample_id=$(echo $LINE|awk -F"," '{print $1}')
  root_dir=$(echo $LINE|awk -F"," '{print $4}')
  star_dir=${root_dir}"/star_reprocessing"
  chip_dir=${root_dir}"/starchip"
if [[ ! `gsutil ls "${chip_dir}/circRNA.5reads.1ind.countmatrix"` ]];then
	cmd="dsub \
    	--project ${PROJECT_ID} \
    	--zones "us-central1-*" \
    	--provider "${provider}" \
    	--logging ${logging} \
    	--disk-size 200 \
    	--boot-disk-size 50  \
    	--machine-type ${machine_type} \
    	--image ${DOCKER} \
    	--input-recursive STAR_CHIP_REF=${starchip_ref} \
    	--input  CHIMERA_FILES=${star_dir}/${sample_id}.Chimeric* \
    	--input  CHIMERA_TAB=${star_dir}/${sample_id}.SJ.out.tab \
    	--env SMTAG=${sample_id} \
    	--output-recursive OUTPUT_DIR="${chip_dir}" \
    	--script ${script} \
    	--preemptible "
	echo $cmd
	$cmd
fi
done
