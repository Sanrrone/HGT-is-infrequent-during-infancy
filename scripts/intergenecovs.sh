#!/bin/bash
#
new="/scratch/project_2007362"

source global_env.sh

bamfile=$1
sname=$(basename $bamfile | sed "s/.bam//g")
bedfile=$2
wd=$3
hepID=$(echo $wd | awk -F"/" '{print $NF}')

cd $wd
###########################################################
ml bedtools
#samtools index $bfile ${bfile}.bai

cp ${bamfile}.bai .
rm -f ${sname}.depths

echo "working in $bamfile | $bedfile"
#format of bgenes
#basescov
#k141_37501	1241616_Staphylococcus_aureus__l_00001	1517	0.00593276	659
#awk -F'\t' -v full=$hepID '{if(NR==FNR){n[$1";;"$2]=$3}else{if($1";;"$2 in n){idx=$1";;"$2; print full"\t"$1"\t"$2"\t"$3"\t"n[idx]"\t"$4"\t"$5}}}' ${sname}.rawcounts ${sname}.basescov > ${sname}.depths

bedtools coverage -a $bedfile -b $bamfile -d \
| awk '{
    region_len[$4] = $3 - $2
    if ($8 > 0) {
        sum_cov[$4] += $8
        covered_bases[$4]++
    }
}
END {
    for (id in region_len) {
        len = region_len[id]
        if (covered_bases[id] > 0) {
            md = sum_cov[id] / covered_bases[id]
            cov_frac = covered_bases[id] / len
        } else {
            md = 0
            cov_frac = 0
        }
        print id, md, cov_frac, len
    }
}' OFS="\t" > ${sname}_tmp_depth.tsv

bedtools coverage -a $bedfile -b $bamfile -counts -S \
        | awk '{print $4, $7}' OFS="\t" > ${sname}_tmp_counts.tsv


awk '
FNR==NR { count[$1]=$2; next }
{
    abundance = (count[$1] == "") ? 0 : count[$1]
    print $1, $4, abundance, $2, $3
}
' ${sname}_tmp_counts.tsv ${sname}_tmp_depth.tsv > ${sname}_ir.depths

rm -f ${sname}_tmp_depth.tsv ${sname}_tmp_counts.tsv ${sname}.bam.bai
