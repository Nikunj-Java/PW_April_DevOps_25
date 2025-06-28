class Server:
    def __init__(self,name,ip):
        self.name=name
        self.ip=ip

    def status(self):
        print(f"{self.name} at {self.ip} is running")

web_server= Server("WebServer","192.168.1.10")
web_server.status()


