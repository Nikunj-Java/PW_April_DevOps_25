#parent class
class Animal:
    def __init__(self,name):
        self.name=name
    def speak(self):
        print(f"{self.name} makes a sound")
#child classes
class Dog(Animal):
    def speak(self):
        print(f"{self.name} says Woof!")
class Cat(Animal):
    def speak(self):
        print(f"{self.name} says Meow")
class Tiger(Animal):
    def speak(self):
        print(f"{self.name} says Roar")

dog1= Dog("Buddy")
Cat1=Cat("Mimi")
tiger=Tiger("White Tiger")

dog1.speak()
Cat1.speak()
tiger.speak()