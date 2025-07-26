from selenium import webdriver

driver= webdriver.Chrome()
driver.get('https://www.google.com')

assert "Google" in driver.title
# open google .com and check for the title of the website
# install Selenium: pip install selenium
