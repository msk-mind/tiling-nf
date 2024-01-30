@Grab('org.apache.commons:commons-csv:1.10.0')
import org.apache.commons.csv.CSVPrinter
import org.apache.commons.csv.CSVFormat

import groovy.json.JsonSlurper

params.outdir = "results"
params.check_slides_exist = false
params.samples_csv = null
params.slide_url_column = 'url'

include { GET_TABLE } from './modules/extract'
include { TILING } from './modules/tiling'

workflow {
    ch_slides = Channel.empty()

    if (params.samples_csv) {
        ch_slides = Channel
            .fromPath(params.samples_csv)
            .splitCsv(header: true)
            .map { [it, file(it[params.slide_url_column], checkIfExists:  params.check_slides_exist)] }
    } else {
        ch_slides = GET_TABLE \
            | splitJson
            | map { [it, file(it[params.slide_url_column], checkIfExists: params.check_slides_exist)] }
    }

    if (params.test) {
        ch_slides = ch_slides.take(5)
    }

    TILING(ch_slides)
}
