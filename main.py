import os
import time

def wait_then_add(settings):
    print("Started background process")
    time.sleep(20)
    
    print("Adding a new endpoint")
    settings.add_endpoint("/hello", "BOO")

if __name__ == "__main__":
    os.system("nim --version")
    os.system("nimble --version")
    os.system("choosenim --version")

    import multiprocessing

    from src import vantage
    
    gateway = vantage.Vantage()
    
    gateway.add_endpoint("/", "domain.com/hello-world")
    
    multiprocessing.Process(target=wait_then_add, args=(gateway,)).start()
    
    gateway.start()
