# facebook_login.py

from selenium import webdriver
from selenium.webdriver.common.by import By
import time

def login_facebook(email, password):
    driver = webdriver.Chrome()
    driver.get("https://www.facebook.com/")
    driver.find_element(By.ID, "email").send_keys(email)
    driver.find_element(By.NAME, "pass").send_keys(password)
    driver.find_element(By.NAME, "login").click()
    time.sleep(5)
    driver.quit()
