from snakemake.utils import validate

configfile: 'config/config.yaml'
validate(config, schema="../schemas/config.schema.yaml")

star_overhang_lengths = config["star_overhang_lengths"].split(",")

# Setup vars
threads_high = int(config["threads"])
threads_mid = int(threads_high/2)
threads_low = 1
