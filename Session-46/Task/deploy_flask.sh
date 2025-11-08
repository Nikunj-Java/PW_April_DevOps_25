#!/bin/bash
# Update system and install dependencies
sudo yum update -y
sudo yum install -y python3 git

# Install Flask and Boto3
pip3 install flask boto3

# Create Flask app directory
mkdir -p /home/ec2-user/flask_app
cd /home/ec2-user/flask_app

# Write the Flask application
cat <<'EOF' > app.py
from flask import Flask, request, render_template_string
import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)

# DynamoDB table reference (use IAM role or local credentials)
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('usertable')

HTML_FORM = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Form</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
  <div class="container mt-5">
    <div class="card shadow p-4">
      <h3 class="text-center mb-4 text-primary">Add User to DynamoDB</h3>
      <form method="POST" action="/submit">
        <div class="mb-3">
          <label for="UserID" class="form-label">User ID</label>
          <input type="text" class="form-control" name="UserID" required>
        </div>
        <div class="mb-3">
          <label for="Email" class="form-label">Email</label>
          <input type="email" class="form-control" name="Email" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Save User</button>
      </form>
    </div>
  </div>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HTML_FORM)

@app.route('/submit', methods=['POST'])
def submit():
    user_id = request.form['UserID']
    email = request.form['Email']
    try:
        table.put_item(Item={'UserID': user_id, 'Email': email})
        return f"<b>✅ User saved successfully!</b><br>UserID: {user_id}<br>Email: {email}<br><br><a href='/'>← Go Back</a>"
    except ClientError as e:
        return f"❌ Error saving user: {e.response['Error']['Message']}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

# Run the app on port 80 in background
sudo nohup python3 /home/ec2-user/flask_app/app.py > /home/ec2-user/flask_app/app.log 2>&1 &
