#!/bin/bash
set -e

# Ensure required env vars are set
: "${OUTPUT_NAME:?OUTPUT_NAME not set}"
: "${KIT_NAME:?KIT_NAME not set}"
: "${MODEL:?MODEL not set}"

# Input and output directories
INPUT_DIR=${INPUT_DIR:-pod5}
OUTPUT_DIR=${OUTPUT_DIR:-output_fastq}
LINES_PER_CHUNK=${LINES_PER_CHUNK:-4000}

echo "Running Dorado basecaller and demux..."
dorado basecaller --kit-name "$KIT_NAME" "$MODEL" "$INPUT_DIR" \
  | dorado demux --kit-name "$KIT_NAME" --emit-fastq --output-dir "$OUTPUT_DIR"

cd "$OUTPUT_DIR" || { echo "Failed to cd into $OUTPUT_DIR"; exit 1; }

for file in *.fastq; do
    if [[ "$file" =~ barcode([0-9]+) ]]; then
        barcode="barcode${BASH_REMATCH[1]}"
    elif [[ "$file" == *unclassified.fastq ]]; then
        barcode="unclassified"
    else
        echo "Skipping unrecognized file: $file"
        continue
    fi

    if [[ ! -s "$file" ]]; then
        echo "Skipping empty file: $file"
        continue
    fi

    mkdir -p "${OUTPUT_NAME}-${barcode}"
    base_name="${file%.fastq}"

    echo "Processing $file into ${OUTPUT_NAME}-${barcode}/"

    split -l "$LINES_PER_CHUNK" -d --additional-suffix=.fastq "$file" "${OUTPUT_NAME}-${barcode}/${base_name}_"
    gzip "${OUTPUT_NAME}-${barcode}/${base_name}_"*.fastq

    rm -f "$file"
done

