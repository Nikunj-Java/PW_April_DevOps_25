#!/bin/bash
sudo yum update -y
sudo yum install -y python3 git

pip install flask boto3

mkdir -p /home/ec2-user/flask_app
cat <<EOF > /home/ec2-user/flask_app/app.py
cd /home/ec2-user/flask_app

cat  <<'EOF' > app.py
from flask import Flask, request, render_template_string
import boto3
from botocore.exceptions import ClientError

app = Flask(__name__)

# DynamoDB resource (uses credentials already configured on your system)
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
table = dynamodb.Table('usertable')

# Simple HTML form (Bootstrap)
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
        # ✅ Must include the same key name as the DynamoDB primary key
        table.put_item(
            Item={
                'UserID': user_id,
                'Email': email
            }
        )
        return f"""
        <b>User saved successfully!</b><br>
        <b>UserID:</b> {user_id}<br>
        <b>Email:</b> {email}<br><br>
        <a href="/">← Go Back</a>
        """
    except ClientError as e:
        return f" Error saving user: {e.response['Error']['Message']}"

if __name__ == '__main__':
    app.run(debug=True)

EOF
sudo python3 app.py &