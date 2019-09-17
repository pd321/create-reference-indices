# create-reference-indices

A snakemake workflow to create reference indices and other supplementary files required for sequence analysis

## Usage

### Dependencies
Snakemake, conda and cookiecutter. Its recommended to first install [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html) as per the instructions for your operating system. Post this snakemake and cookiecutter can be installed using it as follows:-

```bash
conda install -c bioconda -c conda-forge snakemake 
conda install -c conda-forge cookiecutter
```

cookiecutter is a project template system which is helpful in customizing and cloning the workflow.

### Clone the workflow

Use cookiecutter to clone the workflow

```bash
cookiecutter https://github.com/pd321/snakemake-create-refindices.git
```
cookiecutter should prompt you for a project name. This is usually a reference genome version like hg19/hg38/mm10 etc.

```bash
ref_name [hg19]: mm10 # Example input
```
you should now have a directory by this name under git version control.

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
