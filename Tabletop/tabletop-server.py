import json, socket, threading, sys, time

#https://api.tabletopsimulator.com/externaleditorapi/
#https://github.com/Berserk-Games/atom-tabletopsimulator-lua/blob/master/lib/tabletopsimulator-lua.coffee#L108
#Complies with Tabletop Specification, not Atom Coffee Specification

TTS = None
TTS_thread = None

class tabletop_server:
    console = None
    address = "localhost"
    port = 39998
    timeout = 0.001

    client = None
    destination = None
    queue = []

    send_address = "localhost"
    send_port = 39999

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
                msg, conn = self.client.recvfrom(4096)
                for item in self.queue:
                    print("[INFO]: Sending Queued Message")
                    self.client.sendto(item, self.destination)
                self.queue = []
                self.client.close()
                print("[INFO]: " + str(json.loads(msg)) + ", " + str(conn))
            time.sleep(self.timeout)
        except Exception as error:
            self.error(error)

    def error(self, error):
        print("[WARN]: " + str(error), file = sys.stderr)
        time.sleep(1)
        self.setup()

    def ping(self):
        try:
            script = "print(\"hello world\")"
            msg = json.dumps({"messageID": 3, "guid": -1, "script": script})
            #self.console.sendto(msg.encode(), self.destination)
            self.queue.append(msg.encode())
            print("[INFO]: Message Queued")
        except Exception as error:
            self.error(error)

    def get(self):
        try:
            msg = json.dumps({"messageID": 0})
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            s.connect((self.send_address, self.send_port))
            s.sendto(msg.encode(), (self.send_address, self.send_port))
            s.close()
            print("[INFO]: Get Queued")
        except Exception as error:
            self.error(error)

    def set(self, script_states_list):
        try:
            msg = json.dumps({"messageID": 1, "scriptStates": script_states_list})
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            s.connect((self.send_address, self.send_port))
            s.sendto(msg.encode(), (self.send_address, self.send_port))
            s.close()
            print("[INFO]: Set Queued")
        except Exception as error:
            self.error(error)

    def send(self, message):
        try:
            msg = json.dumps({"messageID": 2, "customMessage": message})
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            s.connect((self.send_address, self.send_port))
            s.sendto(msg.encode(), (self.send_address, self.send_port))
            s.close()
            print("[INFO]: Send Queued")
        except Exception as error:
            self.error(error)

    def command(self, lua_script, guid = "=1"):
        try:
            msg = json.dumps({"messageID": 3, "guid": guid, "script": lua_script})
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            s.connect((self.send_address, self.send_port))
            s.sendto(msg.encode(), (self.send_address, self.send_port))
            s.close()
            print("[INFO]: Command Queued")
        except Exception as error:
            self.error(error)

    def direct(self, json_data):
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM, socket.IPPROTO_TCP)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.connect((self.send_address, self.send_port))
        s.sendto(json_data.encode(), (self.send_address, self.send_port))
        s.close()

def worker(task):
    _task = task
    while True:
        _task()

if __name__ == "__main__":
    TTS = tabletop_server()
    TTS.setup()
    TTS_thread = threading.Thread(target = worker, args = (TTS.loop, ))
    TTS_thread.start()
