#!/bin/bash
mkdir -p rawReads
while read id; do
    fasterq-dump "$id" --split-files --threads 4 -O rawReads/
done < SRR_Acc_List.txt
