import requests
from bs4 import BeautifulSoup

url="https://www.google.com/"

response=requests.get(url)

soup= BeautifulSoup(response.text,"html.parser")

print("Page Title:",soup.title.text)

#extracting all links
print("\n links:")

for link in soup.find_all("a"):
    print(link.get("href"))

print("\n Images:")
for img in soup.find_all("img"):
    print(img.get("src"))