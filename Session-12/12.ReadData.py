import os 
if os.path.exists("details.txt"):
    with open("details.txt","r") as file:
        print(file.read())
else:
    print("File Does Not Exist.")