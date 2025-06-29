from datetime import datetime
#1. using strftime  f= formatting
now= datetime.now()
formatted= now.strftime("%Y-%m-%d %H:%M:%S")
print( "Date" ,now)
print( "Date" ,formatted)

#2 using strptime  p=parsing (to convert the string format into datetime format)

date_str="2025-06-29 21:32:24"
parsed= datetime.strptime(date_str,"%Y-%m-%d %H:%M:%S")
print("Parsed Datetime: ",parsed)
