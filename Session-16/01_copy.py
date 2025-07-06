import shutil
import os

#create a file
with open('Sample_file.txt','w') as f:
    f.write('This is a simple file for shutil operations..!')

# copy the file to new location
shutil.copy('Sample_file.txt','Copy_file.txt')

#check if the copied file exists
file_copied=os.path.exists('Copy_file.txt');
print(file_copied)
