from bs4 import BeautifulSoup

## install the dependency before running the above code
## pip install beautifulsoup4
html='<html><body> <h1>Welcome to PW SKILLS</h1></body></html>'
soup= BeautifulSoup(html,'html.parser')
#print(soup.h1.text)

html1="""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Physics Wallah</title>
</head>
<body>

    <h2>PW SKILLS</h2>
    <p class="info">WebAutomation.</p>
    
</body>
</html>
"""
soup1=BeautifulSoup(html1,"html.parser")
print("Title:",soup1.title.text)
print("Headings:",soup1.h2.text)
print("Paragraph:",soup1.find("p",class_="info").text)