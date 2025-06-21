#!/bin/bash
message="hello world world"
echo "Replace first: ${message/world/Bash}"
echo "Replace All: ${message//world/Bash}"
