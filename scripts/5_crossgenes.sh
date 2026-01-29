#!/bin/bash
#   
#SBATCH --job-name=5_crossgenes
#SBATCH --output=log/s5.log
#SBATCH --error=err/s5.err
#SBATCH --partition=test
#SBATCH --account=Project_2007362
#SBATCH --time=00:15:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=2

 
c=$(nproc)
 
source global_env.sh
 
 
rm -rf ${home_project}/13_horizontal_gene_transfer/5_crossgenes
mkdir -p  ${home_project}/13_horizontal_gene_transfer/5_crossgenes
cd ${home_project}/13_horizontal_gene_transfer/5_crossgenes
 
ml blast
ml seqtk
 
#hgt_candidates se obtiene desde R, checkear el 4_interregions.R (o algo asi)
cat ~/hgt/supp_files/hgt_candidates.tsv | while read h s gene
do
        echo $gene > id.txt
        seqtk subseq $new/sandro/HeP_samples/7_fixed/${h}/annot/${h}.ffn id.txt > isolated_gene.ffn
        blastn -query isolated_gene.ffn -db $new/software/hep_bactDB/fixed_bactDB/sbaall -num_threads $c -evalue 0.001 -perc_identity 70 -out ${h}__${s}__$gene.tsv -qcov_hsp_perc 70 -outfmt "6 qseqid sseqid pident qlen slen length"
        #rm -f id.txt isolated_gene.ffn
done
 
rm -f isolated_gene.ffn id.txt
 
for ts in *.tsv
do
        awk -F"\t" '{if(NR==FNR){n[$1]=$2}else{fn=FILENAME; gsub(".tsv","",fn);if($2 in n){split(fn,h1,"__");split(n[$2],h2,"__");if(h1[1]==h2[1])print fn"\t"n[$2]"\t"$3"\t"($6/$4)}}}' $new/software/hep_bactDB/fixed_bactDB/header_map.tsv $ts > tmp
        rm $ts
        mv tmp $ts
done

echo "Done :D"

