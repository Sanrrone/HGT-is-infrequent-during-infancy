#!/bin/bash
#      
#SBATCH --job-name=7_mobile
#SBATCH --output=log/s7.log
#SBATCH --error=err/s7.err
#SBATCH --partition=test
#SBATCH --account=Project_2007362
#SBATCH --time=00:15:00
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --mail-type=END
#SBATCH --mail-user=sandro.valenzuela@helsinki.fi
       
c=$(nproc)
source global_env.sh
       
export PATH=$new/software/mambaforge/bin:$PATH
eval "$(conda shell.bash hook)"
conda activate mefinder
       
#ml blast
hgtc="supp_files/hgt_candidates.tsv"
       
rm -fr ${home_project}/13_horizontal_gene_transfer/7_mobile2
mkdir -p  ${home_project}/13_horizontal_gene_transfer/7_mobile2
cp $hgtc ${home_project}/13_horizontal_gene_transfer/7_mobile2/.
cd ${home_project}/13_horizontal_gene_transfer/7_mobile2
       
hgtc="hgt_candidates.tsv"
ml blast/2.12.0
       
run_mefinder () {
       
        cp "$new/sandro/HeP_samples/7_fixed/$h/annot/${h}.fna" .
        cp "$new/sandro/HeP_samples/7_fixed/$h/annot/${h}.gff" .
  mefinder find \
    -c "${h}.fna" \
    -g "${h}.gff" \
    -t "$c" \
    --temp-dir "$tmp"
}      
       
       
for h in $(cut -f1 $hgtc | sort -u)
do     
  echo "working in $h"
  mkdir $h
  cd $h
  tmp="temp_${h}"
       
  rm -rf "$tmp"
  mkdir -p "$tmp"
       
       
  if ! run_mefinder; then
    f="$tmp/blast/mge_records_blast.json"
       
    # If MEFinder ignored --temp-dir for any reason, also check the default location it logged
    if [[ ! -s "$f" ]]; then
      f="${home_project}/13_horizontal_gene_transfer/7_mobile2/${h}/blast/mge_records_blast.json"
    fi 
       
    if [[ -s "$f" ]]; then
      python - <<PY
import json
p="$f" 
s=open(p,"r",encoding="utf-8",errors="ignore").read()
dec=json.JSONDecoder()
obj, idx = dec.raw_decode(s)  # keep first JSON only
open(p,"w").write(json.dumps(obj))
print("Patched:", p, "kept chars:", idx, "of", len(s))
PY     
      run_mefinder
    else
      echo "mefinder failed and blast json not found at expected paths" >&2
      echo "Checked: $tmp/blast/mge_records_blast.json" >&2
      echo "Checked: ${home_project}/13_horizontal_gene_transfer/7_mobile2/${h}/blast/mge_records_blast.json" >&2
      exit 1
    fi 
  fi   
       
  rm -rf "$tmp"
  cd ..
done   
       
rm -rf $new/tmp/*
echo "Done :D"

