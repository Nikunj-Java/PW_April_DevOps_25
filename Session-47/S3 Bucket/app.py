from flask import Flask, render_template_string, request
import boto3
import os

app=Flask(__name__)

S3_BUCKET = "flask-upload-bucket-7a052569"
S3_REGION = "us-east-1"

s3= boto3.client("s3", region_name=S3_REGION)
HTML_FORM= '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow p-4">
            <h3 class="text-center text-primary mb-4">Upload Image to AWS S3</h3>
            <form action="/upload" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <input type="file" name="file" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-success w-100">Upload</button> 
            </form>
        </div>
    </div>
   
    
</body>
</html>
'''

@app.route('/')
def home():
    return render_template_string(HTML_FORM)

@app.route('/upload', methods=['POST'])
def upload():
    file=request.files['file']
    if file:
        s3.upload_fileobj(
            file,
            S3_BUCKET,
            file.filename
        )
        url=f"https://{S3_BUCKET}.s3.{S3_REGION}.amazonaws.com/{file.filename}"
        return f"File uploaded successfully! Access it <a href='{url}'>here</a>."
if __name__ == '__main__':
    app.run(debug=True)