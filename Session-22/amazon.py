#1. open> Amazon
#2. Search for a product
#3. Scrolls the pages slowly to load Synamic Content
#4. Extract product names and prices (if available)

from selenium import webdriver
from selenium.webdriver.common.by import By 
from selenium.webdriver.common.keys import Keys 
import time

#setup Chrome Driver
options= webdriver.ChromeOptions()
options.add_argument('--start-maximized')
driver=webdriver.Chrome(options=options)

#goto>Amazon
driver.get("https://www.amazon.in")

#search for a product
search_box= driver.find_element(By.ID,"twotabsearchtextbox")
search_box.send_keys("laptop")
search_box.send_keys(Keys.RETURN)

#wait for result to load
time.sleep(5)

#scrolldown slowly to load more products

scroll_pause_time=2
last_height=driver.execute_script("return document.body.scrollHeight")

for _ in range(5): #scroll 5 times
    driver.execute_script("windows.scrollTo(0, documenr.body.scrollHeight);")
    time.sleep(scroll_pause_time)
    new_height= driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height
#extract product title and prices
product = driver.find_element(By.XPATH,"//div[@data-component-type='s-search-result']")


         