import requests


## install the dependency before running the above code
## pip install requests
url="https://www.google.com/"
response=requests.get(url)

#check the response code
if response.status_code == 200:
    print(response.status_code)
    print(response.text[:500])
else:
    print(f"Failed to fecth the page, Status code: {response.status_code}")