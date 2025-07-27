from selenium import webdriver

#launch Chrome
driver= webdriver.Chrome()

#open a facebook
driver.get("https://www.facebook.com/")

#find element by id
driver.find_element("id","email").send_keys("your_email_id")
driver.find_element("name","pass").send_keys("your_password")
driver.find_element("name","login").click()


driver.implicitly_wait(10)

driver.quit()