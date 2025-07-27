from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Setup Chrome driver
options = webdriver.ChromeOptions()
options.add_argument('--start-maximized')
driver = webdriver.Chrome(options=options)

# Go to Amazon
driver.get("https://www.amazon.in")

# Search for a product
search_box = driver.find_element(By.ID, "twotabsearchtextbox")
search_box.send_keys("laptop")
search_box.send_keys(Keys.RETURN)

# Wait for results to load
time.sleep(3)

# Scroll down slowly to load more products
scroll_pause_time = 2
last_height = driver.execute_script("return document.body.scrollHeight")

for _ in range(5):  # Scroll 5 times
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")
    time.sleep(scroll_pause_time)
    new_height = driver.execute_script("return document.body.scrollHeight")
    if new_height == last_height:
        break
    last_height = new_height

# Extract product titles and prices
products = driver.find_elements(By.XPATH, "//div[@data-component-type='s-search-result']")

for product in products:
    try:
        title = product.find_element(By.TAG_NAME, "h2").text
        price = product.find_element(By.CLASS_NAME, "a-price-whole").text
        print(f"{title} - ₹{price}")
    except:
        continue  # Skip items with missing data

# Close the browser
driver.quit()
