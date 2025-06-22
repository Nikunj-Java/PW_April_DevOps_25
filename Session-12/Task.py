import time

def monitor_log(file_path):
    with open(file_path, "r") as file:
        file.seek(0, 2)  # Move to the end of the file
        print(f"Monitoring {file_path} for changes...")
        
        while True:
            line = file.readline()
            if line:  # If there's a new line
                print(line.strip())  
                if "ERROR" in line:  # Check for "ERROR"
                    print("Alert: Error Occurred!")
            else:
                time.sleep(1)  # Wait and check again

# Call the function with the log file path
monitor_log("app.log")