params.dremio.port = 32010
params.dremio.scheme = 'grpc+tcp'

process GET_TABLE {
    executor 'local'
    conda "$moduleDir/environment.yml"

    secret 'DREMIO_PASSWORD'
    secret 'DREMIO_USERNAME'

    output:
    path "table.json"

    script:
    """
    get_table.py \
        -o table.json \
        --scheme ${params.dremio.scheme} \
        --hostname ${params.dremio.hostname} \
        --port ${params.dremio.port} \
        ${params.dremio.space} \
        ${params.dremio.table}
    """

}

