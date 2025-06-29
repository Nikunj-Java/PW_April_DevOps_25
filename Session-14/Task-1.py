import re
mobile_number= input("Enter Your mobile number with country code :")

pattern= r"^(?:\+91[\-\s]?|0)?[6-9]\d{9}$"

if re.match(pattern,mobile_number):
    print(f"{mobile_number} is valid mobile number")
else:
    print(f"{mobile_number} is not a valid mobile number")