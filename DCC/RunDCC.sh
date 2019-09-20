#!/bin/bash

samtools index ${BAMFILE}

DCC ${CHIMERIC} -D -R ${REPEAT_GTF} -an ${REF_GTF} -M  -G -A ${REF_FA} -B ${BAMFILE} -O ${OUTPUT_DIR} -T ${NCORES}
