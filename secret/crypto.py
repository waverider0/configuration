import os, sys, secrets, tempfile, getpass
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SALT_FILE = os.path.join(BASE_DIR, "salt.bin")

def atomic_write(path: str, data: bytes, mode: int = 0o600):
  fd, tmp = tempfile.mkstemp(dir=os.path.dirname(path))
  with os.fdopen(fd, "wb") as f:
    f.write(data)
  os.chmod(tmp, mode)
  os.replace(tmp, path)

def derive_key(password: str, salt: bytes) -> bytes:
  return Scrypt(salt, 32, 2**15, 8, 1).derive(password.encode())

def encrypt(data: bytes, key: bytes) -> bytes:
  nonce = secrets.token_bytes(12)
  return nonce + AESGCM(key).encrypt(nonce, data, None)

def decrypt(data: bytes, key: bytes) -> bytes:
  return AESGCM(key).decrypt(data[:12], data[12:], None)

def rotate_all():
  all_files = [f for f in os.listdir(BASE_DIR) if os.path.isfile(os.path.join(BASE_DIR, f)) and f not in ("crypto.py", "salt.bin")]

  encrypted = [f for f in all_files if f.endswith(".e")]
  plaintext = [f for f in all_files if not f.endswith(".e")]

  old_key = None
  if encrypted:
    old_password = getpass.getpass("Old password: ")
    old_salt = open(SALT_FILE, "rb").read()
    old_key = derive_key(old_password, old_salt)

  while True:
    new_password = getpass.getpass("New password: ")
    new_password2 = getpass.getpass("Confirm new password: ")
    if new_password == new_password2: break
    print("Passwords do not match. Try again.")

  new_salt = secrets.token_bytes(16)
  new_key = derive_key(new_password, new_salt)

  for fname in encrypted:
    path = os.path.join(BASE_DIR, fname)
    data = decrypt(open(path, "rb").read(), old_key)
    atomic_write(path, encrypt(data, new_key))
    print(f"rotated {path}")

  for fname in plaintext:
    plain_path = os.path.join(BASE_DIR, fname)
    data = open(plain_path, "rb").read()
    enc_path = plain_path + ".e"
    atomic_write(enc_path, encrypt(data, new_key))
    os.remove(plain_path)
    print(f"encrypted {plain_path}")

  atomic_write(SALT_FILE, new_salt)

def decrypt_single(file: str):
  enc_path = os.path.join(BASE_DIR, file)
  if not os.path.exists(enc_path): sys.exit(f"File not found: {enc_path}")

  password = getpass.getpass("Password: ")
  key = derive_key(password, open(SALT_FILE, "rb").read())

  data = decrypt(open(enc_path, "rb").read(), key)
  plain_path = enc_path[:-2] if file.endswith(".e") else enc_path
  atomic_write(plain_path, data)
  os.remove(enc_path)
  print(f"decrypted {plain_path}")

if __name__ == "__main__":
  if len(sys.argv) < 2 or sys.argv[1] not in ("-r", "-d", "-l"):
    sys.exit(f"Usage: {sys.argv[0]} -r | -d <file>")

  if sys.argv[1] == "-r": rotate_all()

  elif sys.argv[1] == "-d":
    if len(sys.argv) == 3: decrypt_single(sys.argv[2])
    else: sys.exit(f"Usage: {sys.argv[0]} -d <file>")
