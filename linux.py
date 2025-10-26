#!/usr/bin/env python3
import os, sys, shutil, getpass
from secret.crypto import SALT_FILE, derive_key, decrypt, atomic_write

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

CONFIGS = {
  "config/.gitconfig":              "/home/allen/.gitconfig",
  "config/nvim_init.lua":           "/home/allen/.config/nvim/init.lua",
  "config/github.pub":              "/home/allen/.ssh/github.pub",
  "config/vscode_keybindings.json": "/home/allen/.config/VSCodium/User/keybindings.json",
  "config/vscode_settings.json":    "/home/allen/.config/VSCodium/User/settings.json",
  "config/ssh_config":              "/home/allen/.ssh/config",
  "config/unix/.tmux.conf":         "/home/allen/.tmux.conf",
  "config/unix/.zshrc":             "/home/allen/.zshrc", # chsh -s $(which zsh)
}

SECRETS = {
  ".kdbx.kdbx.e": "/home/allen/.kdbx.kdbx",
  "github.e":     "/home/allen/.ssh/github",
}

if __name__ == "__main__":
  # CONFIGS
  for name, dest in CONFIGS.items():
    src = os.path.join(BASE_DIR, name)
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
