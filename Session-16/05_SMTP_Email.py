import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
 

def send_email(subject,body):
    sender_email="senderemail@gmail.com"
    receiver_email="receiveremail@gmail.com"
    password="your_APP_Password" #your app password
    
    #goto> https://myaccount.google.com
    #select>security> enable 2 step-verification
    #goto> search bar> app password>
    # create the password and use it here
    
    #msg=MIMEText(body)
    msg=MIMEMultipart()
    msg["subject"]=subject
    msg["From"]=sender_email
    msg["To"]=receiver_email
    html_content='<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Email</title></head><body><h1>SMTP Email Example</h1><hr><h2>Email For Notification</h2><p>This is HTML Emal</p><p>This is Test Email</p></body></html>'
    msg.attach(MIMEText(html_content,'html'))

    with smtplib.SMTP("smtp.gmail.com",587) as server:
        server.starttls() # encrypting the connection
        server.login(sender_email,password)
        server.send_message(msg)

send_email("Backup Completed!","Backup Completed at 09:03:49 Successfully!")