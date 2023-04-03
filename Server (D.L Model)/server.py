import base64
from http.server import HTTPServer,BaseHTTPRequestHandler
import json
import logging
import test
host="192.168.1.103"
port=9999

def savesound (post_data):
    stringObject = post_data.decode("utf-8")
    json_object = json.loads(stringObject)
    soundData = json_object["soundBase64"].encode()
    content = base64.b64decode(soundData)
    with open('sound.mp3', 'wb') as fw:
        fw.write(content)


class HomeServer(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_response()
        self.wfile.write(bytes("Verileriniz bunlar...", "utf-8"))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])  # <--- Gets the size of data
        post_data = self.rfile.read(content_length)  # <--- Gets the data itself
        # logging.info("POST request,\nPath: %s\nHeaders:\n%s\n\nBody:\n%s\n",
        #              str(self.path), str(self.headers), post_data.decode('utf-8'))
        savesound(post_data)
        predict=test.analizbaslat()
        self._set_response()
        # self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))
        self.wfile.write(bytes('{"label":"'+yanit["label"][int(predict[0])]+'","resim":"'+predict[0]+'"}',"utf-8"))

yanit={
    "label":["Alternator","Bad Bearing","Bad Cv Axle","Bad Serpentine Belt","Bad Brake Pads","Exhaust Leak","Flooded Engine","Low Power Steering Fluid","Rod Knock","Seized Engine"]
}

server=HTTPServer((host,port),HomeServer)

print("Server now running")
logging.basicConfig(level=logging.INFO)
logging.info('Starting httpd...\n')

try:
    server.serve_forever()
except KeyboardInterrupt:
    server.server_close()

logging.info('Stopping httpd...\n')

print("Server stopped")