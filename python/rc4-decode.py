from wincrypto import CryptCreateHash, CryptHashData, CryptDeriveKey, CryptEncrypt, CryptImportKey, CryptExportKey
from wincrypto.constants import CALG_SHA1, CALG_RC4, bType_SIMPLEBLOB
from binascii import unhexlify

#derive key from password
sha1_hasher = CryptCreateHash(CALG_SHA1)
CryptHashData(sha1_hasher, b'<KEY HERE>')
RC4_KEY_FULL = CryptDeriveKey(sha1_hasher, CALG_RC4)

CryptHashData(sha1_hasher, b'<KEY HERE>')
RC4_KEY_TRAIL = CryptDeriveKey(sha1_hasher, CALG_RC4)

print(RC4_KEY_FULL.key.hex())
print(RC4_KEY_TRAIL.key.hex())
