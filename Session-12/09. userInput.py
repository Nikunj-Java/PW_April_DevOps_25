user_input= input('Enter a Number')

if user_input.isdigit():
    num=int(user_input)
    print('You have Entered a Valid Number:',num)
else:
    print('Invalid Input!, Please Enter a Number')