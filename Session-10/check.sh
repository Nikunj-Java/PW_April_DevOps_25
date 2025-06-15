#!/bin/bash

username_file="listusers.txt"

if [ ! -f "$username_file" ]; then
  echo "Error: $username_file not found."
  exit 1
fi

for username in $(cat "$username_file"); do

  if id "$username" &>/dev/null; then
    echo "User $username already exists."
    continue
  fi


  sudo useradd -m -s /bin/bash  "$username"


  echo "User $username created."
done


echo "User creation completed."

