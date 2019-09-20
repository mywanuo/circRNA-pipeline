#!/bin/bash
readonly PROJECT_ID=${1}
readonly provider="google-v2"
readonly logging=${2}
readonly machine_type=${3}
readonly ncores=${4}
readonly script=${6}
readonly reference=${5}
readonly DOCKER="quay.io/xujishu/circrna-tools:0.0.1"
while read line
do
  fname=$(echo $line|awk '{print $1}')
  floc=$(echo $line|awk '{print $2}')
  if [[ $fname == "ref_fa" ]];then
        ref_fa=$floc
  elif [[ $fname == "ref_gtf" ]];then
        ref_gtf=$floc
  elif [[ $fname == "repeat_gtf" ]];then
        repeat_gtf=$floc
  fi
done<$reference

while read -r LINE
do
  sample_id=$(echo $LINE|cut -f 1 -d",")
  indir=$(echo $LINE|cut -f 4 -d",")
  bamfile=${indir}"/star_reprocessing/"$sample_id".Aligned.sortedByCoord.out.bam"
  chimeric=${indir}"/star_reprocessing/"${sample_id}".Chimeric.out.junction"
  junction=${indir}"/star_reprocessing/"${sample_id}".SJ.out.tab"
  outdir=${indir}"/DCC"
  if [[ ! `gsutil ls "${outdir}/CircRNACount"` ]];then
   echo "${outdir}/CircRNACount"
  cmd="dsub \
    --project ${PROJECT_ID} \
    --zones "us-central1-*" \
    --provider "${provider}" \
    --logging ${logging} \
    --disk-size 200  \
    --boot-disk-size 50 \
    --machine-type ${machine_type} \
    --image ${DOCKER} \
    --input BAMFILE=${bamfile} \
    --input REPEAT_GTF=${repeat_gtf} \
    --input REF_FA=${ref_fa} \
    --input REF_FA_FAI=${ref_fa}".fai" \
    --input REF_GTF=${ref_gtf} \
    --input JUNCTION=${junction} \
    --input CHIMERIC=${chimeric} \
    --env NCORES=${ncores} \
    --output-recursive OUTPUT_DIR=${outdir} \
    --script ${script} \
    --preemptible " 
echo $cmd
$cmd
fi
done
