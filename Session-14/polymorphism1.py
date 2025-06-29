import math

class Shape:
    def area(self):
        pass #abstract method
class Circle(Shape):
    def __init__(self,radius):
        self.radius=radius
    def area(self):
        return math.pi * self.radius ** 2

class Square(Shape):
    def __init__(self,side):
        self.side=side
    def area(self):
        return self.side ** 2

class Reactangle(Shape):
    def __init__(self,l,b):
        self.l=l
        self.b=b
    def area(self):
        return self.l * self.b

shapes=[Circle(5),Square(10),Reactangle(4,6)]

for shape in shapes:
        print(f"Area: {shape.area():.2f}")