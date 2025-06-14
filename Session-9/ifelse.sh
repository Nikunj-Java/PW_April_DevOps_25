#!/bin/bash

echo "Enter a Number:"

read num

if [ $num -gt 10 ]; then
echo "The Number is Greater than 10"
else
echo "The Number is 10 or less"
fi
