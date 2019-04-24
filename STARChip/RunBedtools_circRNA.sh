#!/bin/bash

circrna_name=$(basename ${CIRCRNA_GENES})
outdir=$(dirname ${OUTPUTS})

if [[ $circrna_name =~ "csv" ]];then
	file_wo_ext="${circrna_name%.csv}"
	out_prefix=${outdir}/${file_wo_ext}
	cat ${CIRCRNA_GENES} |awk -F"," '{if($1~"chr")print $_}'|awk -F"," '{sub(":"," ",$1);print $_}'|awk  '{sub("-"," ",$2);print $_}'|awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}' >circRNA.bed
else
	out_prefix=${outdir}/${circrna_name}
	cat ${CIRCRNA_GENES} |awk '{if($1~"chr")print $_}'|awk '{sub(":"," ",$1);print $_}'|awk '{sub("-"," ",$2);print $_}'|awk  '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8}' >circRNA.bed
fi

echo $out_prefix
bedtools intersect -a circRNA.bed -b ${CIRCRNA_DB}/circRNA_db_liftover_grch38.bed -c -F 0.5  -f 0.50 -c >${out_prefix}.overlap.circBase.bed
bedtools intersect -a circRNA.bed -b ${CIRCRNA_DB}/Rajewsky_2015_human_cortex_liftover_grch38.bed -c -F 0.5  -f 0.50 -c >${out_prefix}.overlap.Ragjewsky2015.bed
