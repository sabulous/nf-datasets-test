# nf-datasets-test  

A minimal Nextflow pipeline that reads a text file and produces:
- `first3.txt`
- `last3.txt`

## Run locally
```bash
nextflow run main.nf --input data/sample.txt --outdir results