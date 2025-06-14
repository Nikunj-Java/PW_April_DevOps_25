#!/bin/bash


DIR="my_files"

NUM_OF_FILES=4


mkdir -p $DIR

for i in $(seq 1 $NUM_OF_FILES); do
    FILE="$DIR/file_$i.txt"
    echo "This is file number $i" > $FILE
    echo "Created $FILE"
done

echo "File creation completed!"
