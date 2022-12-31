import nimporter

import example

from lmdbm import Lmdb

from pathlib import Path

class Vantage:
    
    def __init__(self, ip: str = "", port: int = 8080, threads: int = 1) -> None:
        
        # TODO: Add validation to these values to check if they're open/are IP addresses
        self._ip: str = ip
        self._port: int = port
        self._threads: int = threads
        
        self._db_file = str(Path("/testdb").absolute())
        self._gateway = example.newGateway(self._db_file)
    
    # ? Properties
    @property
    def ip(self):
        return self._ip
    
    @ip.setter
    def ip(self, ip: str):
        if not isinstance(ip, str):
            raise TypeError("IP must be a string")
        
        self._ip = ip
    
    @property
    def port(self):
        return self._port
    
    @port.setter
    def port(self, port: int):
        if not isinstance(port, int):
            raise TypeError("Port must be an integer")
        
        self._port = port
    
    @property
    def threads(self):
        return self._threads
    
    @threads.setter
    def threads(self, threads: int):
        if not isinstance(threads, int):
            raise TypeError("Threads must be a boolean")
        
        if threads <= 0:
            raise ValueError("Thread count must be >= 1")
        
        self._threads = threads
    
    def add_endpoint(self, endpoint: str, redirect: str):
        # self._gateway.addEndpoint(endpoint, redirect)
        
        with Lmdb.open(self._db_file, "c") as db:
            db[endpoint.encode("utf-8")] = redirect.encode("utf-8")
        
    def remove_endpoint(self, endpoint: str):
        # self._gateway.delEndpoint(endpoint)
        
        with Lmdb.open(self._db_file, "c") as db:
            del db[endpoint]
        
    def has_endpoint(self, endpoint: str) -> bool:
        # return self._gateway.hasEndpoint(endpoint)
    
        with Lmdb.open(self._db_file, "c") as db:
                return endpoint in db.keys()
            
    def has_redirect(self, redirect: str) -> bool:
        with Lmdb.open(self._db_file, "c") as db:
                return redirect in db.values()
        
    def start(self):
        self._gateway.start(
            # First pass in the IP address
            self.ip,
            
            # Second pass in the port
            self.port,
            
            # Third pass in the amount of threads we need to use
            self.threads,
            
            # Pass in the database this API should read from
            self._db_file
        )