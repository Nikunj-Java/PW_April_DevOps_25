from selenium import webdriver

#Launch Chrome
driver= webdriver.Chrome()

#open web page
driver.get("https://www.google.com")

#find an element by id
# goto>website>find which element to be discovered> right click from there> inspect element>get the id,name,attribute,path,css,fullxpath,xpath
search_box= driver.find_element("name","q")
search_box.send_keys("OpenAI ChatGPT")

search_box.submit()
driver.implicitly_wait(10)
print("Page Title: ",driver.title)

driver.quit()