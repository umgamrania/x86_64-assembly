from socket import *
s = socket(AF_INET, SOCK_STREAM)
s.connect(("0.0.0.0", 8080))

while True:
	msg = input("MESSAGE> ")
	s.send(msg.encode("utf-8"))

