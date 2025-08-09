#!/usr/bin/env python3
import os, sys, shutil, getpass
from secret.crypto import SALT_FILE, derive_key, decrypt, atomic_write

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

CONFIGS = {
	".gitconfig":   r"C:\Users\allen\.gitconfig",
	".wezterm.lua": r"C:\Users\allen\.wezterm.lua",
	"github.pub":   r"C:\Users\allen\.ssh\github.pub",
	"init.lua":     r"C:\Users\allen\AppData\Local\nvim\init.lua",
	"startup.bat":  r"C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\startup.bat", # requires admin
	"ssh_config":   r"C:\Users\allen\.ssh\config",
}

SECRETS = {
	".kdbx.kdbx.e": r"C:\Users\allen\.kdbx.kdbx",
	"github.e":     r"C:\Users\allen\.ssh\github",
}

if __name__ == "__main__":
	# CONFIGS
	for name, dest in CONFIGS.items():
		src = os.path.join(BASE_DIR, "config", name)
		if not os.path.exists(src): continue
		os.makedirs(os.path.dirname(dest), exist_ok=True)
		shutil.copy(src, dest)
		print(f"copied -> {dest}")

	# SECRETS
	password = getpass.getpass("Password: ")
	key = derive_key(password, open(SALT_FILE, "rb").read())

	for name, dest in SECRETS.items():
		src = os.path.join(BASE_DIR, "secret", name)
		if not os.path.exists(src): continue
		os.makedirs(os.path.dirname(dest), exist_ok=True)
		atomic_write(dest, decrypt(open(src, "rb").read(), key))
		print(f"decrypted -> {dest}")
