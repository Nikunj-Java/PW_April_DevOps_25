
class server:
    def __init__ (self,serverID, IP_address):
        self.serverID = serverID
        self.IP_address = "offline"
        self.memory_usage = 0

    def start (self):
        self.status = "online"
        print(f"Server {self.serverID} stared")
    
    def stop (self):
        self.status = "offline"
        print(f"Server {self.serverID} stopped")
    def restart (self):
        self.stop()
        self.start()
        print(f"Server {self.serverID} restarted")

    def update_status (self, new_satus ):
        self.status = new_satus
        print(f"Server {self.serverID} status updated to {self.status}")
server1 = server("SRV001", "192.168.1.100")
server2 = server("SRV001", "192.168.1.100")


server1.start()
print(server1.status)

server2.start()
print(server2.status)
 
server1.update_status("busy")
server2.update_status("Online")
