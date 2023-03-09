from snakemake.utils import validate,available_cpu_count

configfile: 'config.yaml'
# validate(config, schema="schemas/config_schema.yaml")

star_overhang_lengths = config["star_overhang_lengths"].split(",")

# Setup vars
threads_high = available_cpu_count()
threads_mid = int(threads_high/2)
threads_low = int(threads_high/4)
