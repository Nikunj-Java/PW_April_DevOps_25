# For Loop
for i in range(1,10):
    print(f"cheking Server {i}....")

#while Loop
server_up=False
while not server_up:
    print("Waiting for the server to start.....")
    server_up= True
print("Server is Running and Up!")