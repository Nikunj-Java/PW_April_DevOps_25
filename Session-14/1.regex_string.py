message=" Hello To Devops World! "

#1. Remove leading and Trainling Spaces
print("1. strip():",message.strip())

#2 convert to uppercase
print("2. upper():",message.upper())

#3 convert to lowercase
print("3. lower():",message.lower())

#4 replace a word
print("4. replace():",message.replace("Devops","Python"))

#5 check if string starts with a word
print("5. startswith('Hello'):",message.strip().startswith("Hello"))

#6 check if string ends with a word
print("6. endswith('World'):",message.strip().endswith("World!"))

#7 find a position of substring
print("7. find('Devops'):",message.find("Devops"))

#8 count how many times a word appears
print("8. count('o'):",message.count("o"))

#9 Split the string into list
words=message.strip().split(" ")
print("9. split():",words)

#10 Join the list back into a string with "-"
print("10. join():","-".join(words))

#11 Sentance Case or Capitalize Each Word
print("11. Capitalize():",message.strip().capitalize()) # Depricated

#12 check all characters are alphabets
print("12. isalpha():","Hello".isalpha())

#13 check all characters are alphabets
print("12. isdigit():","12345".isdigit())