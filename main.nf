params.dremio.port = 32010
params.dremio.scheme = 'grpc+tcp'

process GET_SLIDES {
    executor 'local'
    conda "$moduleDir/environment.yml"

    secret 'DREMIO_PASSWORD'
    secret 'DREMIO_USERNAME'

    output:
    path "samples.json"

    script:
    """
    get_tables.py \
        -o samples.json \
        --scheme ${params.dremio.scheme} \
        --hostname ${params.dremio.hostname} \
        --port ${params.dremio.port} \
        ${params.dremio.space} \
        ${params.dremio.table}
    """

}

