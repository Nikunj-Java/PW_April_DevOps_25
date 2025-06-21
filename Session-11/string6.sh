#!/bin/bash
file="photo.jpg"

echo "Remove Shortest Suffix: ${file%.*}"
echo "Remove extension: ${file%%.*}"
