#!/usr/bin/env python3

import os, sys, shutil, subprocess

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SECRETS_DIR = os.path.join(BASE_DIR, "secrets")
ENCRYPTED_ARCHIVE = os.path.join(BASE_DIR, "secrets.tar.gz.age")

def encrypt_secrets():
  if not os.path.exists(SECRETS_DIR): raise FileNotFoundError("secrets/ directory not found")
  if os.path.exists(ENCRYPTED_ARCHIVE): os.remove(ENCRYPTED_ARCHIVE)
  tar = subprocess.Popen(["tar", "-cz", "-C", BASE_DIR, "secrets"], stdout=subprocess.PIPE)
  age = subprocess.Popen(["age", "--passphrase", "--armor", "-o", ENCRYPTED_ARCHIVE], stdin=tar.stdout)
  tar.stdout.close()
  tar.wait()
  age.wait()
  if tar.returncode != 0 or age.returncode != 0: raise RuntimeError("Encryption failed")
  print(f"encrypted -> {os.path.basename(ENCRYPTED_ARCHIVE)}")
  shutil.rmtree(SECRETS_DIR); print(f"deleted: {SECRETS_DIR}")

def decrypt_secrets():
  if not os.path.exists(ENCRYPTED_ARCHIVE): raise FileNotFoundError(f"{ENCRYPTED_ARCHIVE} not found")
  if os.path.exists(SECRETS_DIR): shutil.rmtree(SECRETS_DIR)
  age = subprocess.Popen(["age", "--decrypt", ENCRYPTED_ARCHIVE], stdout=subprocess.PIPE)
  tar = subprocess.Popen(["tar", "-xzf", "-", "-C", BASE_DIR], stdin=age.stdout)
  age.stdout.close()
  age.wait()
  tar.wait()
  if age.returncode != 0 or tar.returncode != 0: raise RuntimeError("Decryption failed")
  print(f"decrypted -> {SECRETS_DIR}/")

if __name__ == "__main__":
  if len(sys.argv) != 2 or sys.argv[1] not in {"encrypt", "decrypt"}: sys.exit("Usage: secret_manager.py encrypt|decrypt")
  if sys.argv[1] == "encrypt": encrypt_secrets()
  else: decrypt_secrets()
