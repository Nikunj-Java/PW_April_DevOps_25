from selenium import webdriver

driver = webdriver.Chrome()

def test_facebook():
    driver.get("https://www.facebook.com")
    title = driver.title
    title_expected = "Facebook – log in or sign up"
    print(title)

    try:
        assert title == title_expected
        print("Titles matched")
    
    except AssertionError:
        print("Titles did not matched")
    
    finally:
        driver.quit()

if __name__ == "__main__":
    test_facebook()
