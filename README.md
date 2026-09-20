# LongRead Variant Analysis

A reproducible Nextflow workflow for long-read Oxford Nanopore sequencing variant analysis using HG003 chromosome 20 demonstration data.

## Overview

This project implements an end-to-end long-read variant analysis workflow using Nextflow.

The pipeline performs:

1. FASTQ quality control
2. Reference genome indexing
3. Read alignment
4. BAM quality control
5. Clair3 long-read variant calling
6. Variant statistics using bcftools
7. Variant benchmarking using hap.py

## Workflow

```text
ONT FASTQ
   |
   v
FASTQ QC
   |
   v
Reference indexing
   |
   v
Read alignment
   |
   v
BAM QC
   |
   v
Clair3 variant calling
   |
   v
bcftools statistics
   |
   v
hap.py benchmarking
