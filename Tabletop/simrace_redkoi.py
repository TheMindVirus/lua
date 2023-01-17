import json, socket, threading, sys, time, math, pygame

SRS = None
SRS_thread = None

PYG = None
PYG_thread = None

data = \
{
    "angle": 15.0 / math.pi,
    "drive": 15.0,
}

class simrace_server:
    console = None
    address = "localhost"
    port = 65432
    timeout = 0.01

    client = None
    destination = None

    def setup(self):
        try:
            print("[INFO]: Reconnecting...")
            self.console = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
            self.console.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.console.bind((self.address, self.port))
            self.console.listen(socket.SOMAXCONN)
        except Exception as error:
            self.error(error)

    def loop(self):
        try:
            self.client, self.destination = self.console.accept()
            print("[INFO]: " + str(self.client) + ", " + str(self.destination))
            if self.client:
                self.client.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
                self.client.setsockopt(socket.SOL_SOCKET, socket.SO_RCVTIMEO, 1000)
                msg, conn = self.client.recvfrom(4096)
                if msg[0:3] == b"GET":
                    payload = json.dumps(data).encode()
                    headers = "HTTP/1.1 200 OK\r\n"
                    headers += "Content-Type: text/plain\r\n"
                    headers += "Content-Length: " + str(len(payload)) + "\r\n"
                    headers += "Access-Control-Allow-Origin: *\r\n"
                    headers += "\r\n"
                    payload = headers.encode() + payload
                    self.client.sendto(payload, self.destination)
                self.client.close()
            time.sleep(self.timeout)
        except Exception as error:
            self.error(error)

    def error(self, error):
        print("[WARN]: " + str(error), file = sys.stderr)
        time.sleep(1)
        self.setup()

class pygame_server:
    count = 0
    rigs = None
    polling = 0.1
    
    def setup(self):
        pygame.joystick.init()
        self.count = pygame.joystick.get_count()
        self.rigs = [pygame.joystick.Joystick(x) for x in range(self.count)]
    
    def loop(self):
        global data
        self.setup()
        x1 = self.rigs[0].get_axis(0)
        #y1 = self.rigs[0].get_axis(1)
        x2 = self.rigs[0].get_axis(5)
        y2 = self.rigs[0].get_axis(4)
        #a = self.rigs[0].get_button(0)
        #b = self.rigs[0].get_button(1)
        print(y2)
        data["angle"] = x1 * (15.0 / math.pi) 
        data["drive"] = (x2 - y2) * 15.0
        print(data)
        time.sleep(self.polling)

def worker(task):
    _task = task
    while True:
        _task()

if __name__ == "__main__":
    PYG = pygame_server()
    PYG.setup()
    PYG_thread = threading.Thread(target = worker, args = (PYG.loop, ))
    PYG_thread.start()
    SRS = simrace_server()
    SRS.setup()
    SRS_thread = threading.Thread(target = worker, args = (SRS.loop, ))
    SRS_thread.start()
