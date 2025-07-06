import os, shutil, smtplib
from datetime import datetime
from email.mime.text import MIMEText

def check_logs(file_path):
    errors = []
    with open(file_path, "r") as f:
        for line in f:
            if "ERROR" in line:
                errors.append(line.strip())
    return errors

def backup_data(source, backup_dir):
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_file = os.path.join(backup_dir, f"backup_{timestamp}.zip")
    shutil.make_archive(backup_file.replace(".zip", ""), 'zip', source)
    return backup_file

def send_email(subject, body):
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = "admin@example.com"
    msg['To'] = "devops@example.com"

    with smtplib.SMTP("smtp.example.com", 587) as server:
        server.starttls()
        server.login("admin@example.com", "your_password")
        server.send_message(msg)

# -- Run automation --
errors = check_logs("system.log")
if errors:
    backup_path = backup_data("D:/important_data", "D:/backups")
    send_email("Error Detected - Backup Done", f"Errors:\n{chr(10).join(errors)}\nBackup: {backup_path}")
    print("Task done with error notification")
else:
    print(" No errors found.")