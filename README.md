# create-reference-indices

A snakemake workflow to create reference indices and other supplementary files required for sequence analysis

## Usage

### Editing config file

Edit config file to point to correct reference fasta and gtf annotation file.

```bash
fa: 'ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/GRCh37_mapping/GRCh37.primary_assembly.genome.fa.gz'
gtf: 'ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_31/GRCh37_mapping/gencode.v31lift37.annotation.gtf.gz'
```
Refer to the config file for details of other configurable params

### Launching the workflow

Launch using conda as follows
```bash
snakemake --use-conda
```
This will tell snakemake to create environments for the different tools used.
