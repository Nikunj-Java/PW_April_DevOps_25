from abc import ABC ,abstractmethod

class Car(ABC):
    @abstractmethod
    def start_engine(self):
        pass
class Tesla(Car):
    def start_engine(self):
        print("Starting Tesla Engine Silently......!")
class Tata(Car):
    def start_engine(self):
        print("Starting TATA Engine Silently.......!")

my_car= Tesla()
my_car.start_engine()

my_car2=Tata()
my_car2.start_engine()