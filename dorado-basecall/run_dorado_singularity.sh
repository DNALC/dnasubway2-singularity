#!/bin/bash
set -e

if [ "$#" -ne 5 ]; then
  echo "Usage: $0 MODEL KIT_NAME OUTPUT_NAME INPUT_DIR OUTPUT_DIR"
  echo "Example: $0 fast SQK-RBK114-96 testname /data/jacobs/dorado-test/pod5 /data/jacobs/dorado-test/output_singularity"
  exit 1
fi

MODEL=$1
KIT_NAME=$2
OUTPUT_NAME=$3
HOST_INPUT_DIR=$4
HOST_OUTPUT_DIR=$5

singularity run \
  --bind "$HOST_INPUT_DIR":/pod5 \
  --bind "$HOST_OUTPUT_DIR":/output_fastq \
  --env INPUT_DIR=/pod5 \
  --env OUTPUT_DIR=/output_fastq \
  --env OUTPUT_NAME="$OUTPUT_NAME" \
  --env KIT_NAME="$KIT_NAME" \
  --env MODEL="$MODEL" \
  dorado_pipeline.sif

