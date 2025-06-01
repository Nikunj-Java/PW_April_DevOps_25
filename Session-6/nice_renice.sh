#! /bin/bash

echo "Starting a Background CPU-Intensive process with nice and renice value 10...."
nice -n 10 bash -c 'for i in {1..100}; do echo "Nice Process running ....$i"; sleep 1; done' &
PID=$!

echo "Process started with PID: $PID"
sleep 20 # let it run for a few seconds

echo "Now changing the priority of PID $PID using renice to -5 (higher priority)..."
sudo renice 5 -p $PID

echo "Use 'top -p $PID or 'htop' to observer the priority in real time."