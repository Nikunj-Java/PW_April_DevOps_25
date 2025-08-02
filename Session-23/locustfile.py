from locust import HttpUser,task,between

class JsonPlaceholderUser(HttpUser):
    wait_time=between(1,2)
    host="https://jsonplaceholder.typicode.com"
    
    @task
    def getUsers(self):
        self.client.get("/users")