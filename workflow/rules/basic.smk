rule get_fa:
    output: "fa/genome.fa"
    conda:
        "../envs/aria2.yaml"
    threads: threads_low
    params:
        fa_url = config['fa']
    shell:
        'aria2c -x8 --out {output}.gz {params.fa_url} && '
        'gunzip {output}.gz'

rule get_gtf:
    output: temp("gtf/genes_raw.gtf")
    conda:
        "../envs/aria2.yaml"
    threads: threads_low
    params:
        gtf_url = config['gtf']
    shell:
        'aria2c -x8 --out {output}.gz {params.gtf_url} && '
        'gunzip {output}.gz'

rule get_transcript_fa:
    output: "fa/transcripts.fa"
    conda:
        "../envs/aria2.yaml"
    threads: threads_low
    params:
        transcript_fa_url = config['transcripts_fa']
    shell:
        'aria2c -x8 --out {output}.gz {params.transcript_fa_url} && '
        'gunzip {output}.gz'

rule get_blacklist_bed:
    output: "fa/blacklist_regions.bed"
    conda:
        "../envs/aria2.yaml"
    threads: threads_low
    params:
        blacklist_bed_url = config['blacklist_bed_url']
    shell:
        'aria2c -x8 --out {output}.gz {params.blacklist_bed_url} && '
        'gunzip {output}.gz'

rule get_gentrome:
    input:
        fa = rules.get_fa.output,
        transcript_fa = rules.get_transcript_fa.output
    output:
        gentrome_fa = "fa/gentrome.fa"
    threads: threads_low
    shell:
        'cat {input.transcript_fa} {input.fa} > {output}'

rule remove_parY:
    input:
        rules.get_gtf.output
    output:
        filt_gtf = "gtf/genes_parY_filt.gtf",
        par_y_gtf = "gtf/parY.gtf"
    threads: threads_low
    shell:
        'grep "_PAR_Y" {input} > {output.par_y_gtf} && '
        'grep -v "_PAR_Y" {input} > {output.filt_gtf}'

rule get_final_gtf:
    input:
        rules.remove_parY.output.filt_gtf if config['filt_parY'] else rules.get_gtf.output
    output:
        "gtf/genes.gtf"
    threads: threads_low
    shell:
        'mv -v {input} {output}'

rule faidx:
    input: rules.get_fa.output
    output: "fa/genome.fa.fai"
    log: "logs/faidx.log"
    threads: threads_low
    wrapper:
        "v1.23.5/bio/samtools/faidx"

rule fa_dict:
    input: rules.get_fa.output
    output: "fa/genome.fa.dict"
    conda:
        "../envs/samtools.yaml"
    shell:
        'samtools dict -o {output} {input}'

rule chrom_sizes:
    input: rules.faidx.output
    output: "fa/genome.chrom.sizes"
    threads: threads_low
    shell:
        'cut -f1,2 {input} > {output}'

rule get_decoys_for_salmon:
    input: rules.get_fa.output
    output: "misc/decoys.txt"
    shell:
        'grep "^>" {input} | cut -d " " -f 1 > {output} && '
        'sed -i -e \'s/>//g\' {output}'

rule get_tx_2_gene_map:
    input: rules.get_final_gtf.output
    output: "gtf/tx2gene.tsv"
    shell:
        'grep -P "\\ttranscript\\t\d" {input}|'
        'cut -f9|'
        'awk -F\';\' \'BEGIN{{OFS="\\t";}} {{print $2,$1;}}\'|'
        'sed \'s/transcript_id //\'|'
        'sed \'s/gene_id //\'|'
        'sed \'s/"//g\'|'
        'sed \'s/^ //\'|'
        'sed \'1s/^/TXNAME\\tGENEID\\n/\' > {output}'

rule get_gene_info:
    input: rules.get_final_gtf.output
    output: "gtf/geneinfo.tsv"
    shell:
        'grep -P \"\\ttranscript\\t\d\" {input}|'
        'cut -f9|'
        'awk -F\';\' \'BEGIN{{OFS="\\t";}} {{print $1,$3,$4;}}\'|'
        'sed \'s/gene_type //\'|'
        'sed \'s/gene_id //\'|'
        'sed \'s/gene_name //\'|'
        'sed \'s/"//g\'|'
        'sed \'s/^ //\'|'
        'perl -pe \'s/\.\d.*?\t/\t/g\'|'
        'sort|'
        'uniq|'
        'sed \'1s/^/GENEID\\tGENETYPE\\tGENENAME\\n/\' > {output}'
