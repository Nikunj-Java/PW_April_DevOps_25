import re

pattern=r"^[6-9]\d{9}$"

mobile_number="9876712356"

if re.match(pattern,mobile_number):
    print(f"{mobile_number} is valid mobile number")
else:
    print(f"{mobile_number} is not a valid mobile number")