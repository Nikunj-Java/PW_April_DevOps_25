class Dog:
    def __init__(self,name,breed):
        self.name=name
        self.breed=breed
    def bark(self):
        print(f"{self.name} says Woof!")

my_dog= Dog("Buddy","Labrador")
my_dog2=Dog("Tom","Desi")

my_dog.bark()
my_dog2.bark()