#!/usr/bin/env python3

import os, shutil
import secret_manager as sm

HOME = os.path.expanduser("~")
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

if os.name == "nt":
  dotfiles = {
    "dotfiles/.gitconfig"              : f"{HOME}/.gitconfig",
    "dotfiles/github.pub"              : f"{HOME}/.ssh/github.pub",
    "dotfiles/vscode_keybindings.json" : f"{HOME}/AppData/Roaming/VSCodium/User/keybindings.json",
    "dotfiles/vscode_settings.json"    : f"{HOME}/AppData/Roaming/VSCodium/User/settings.json",
    "dotfiles/ssh_config"              : f"{HOME}/.ssh/config",
    "dotfiles/windows/startup.bat"     : "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup/startup.bat",
  }
  secrets = (
    f"{HOME}/.kdbx.kdbx",
    f"{HOME}/.ssh/github",
  )
else:
  dotfiles = {
    "dotfiles/.gitconfig"              : f"{HOME}/.gitconfig",
    "dotfiles/nvim_init.lua"           : f"{HOME}/.config/nvim/init.lua",
    "dotfiles/github.pub"              : f"{HOME}/.ssh/github.pub",
    "dotfiles/vscode_keybindings.json" : f"{HOME}/.config/VSCodium/User/keybindings.json",
    "dotfiles/vscode_settings.json"    : f"{HOME}/.config/VSCodium/User/settings.json",
    "dotfiles/ssh_config"              : f"{HOME}/.ssh/config",
    "dotfiles/unix/.tmux.conf"         : f"{HOME}/.tmux.conf",
    "dotfiles/unix/.zshrc"             : f"{HOME}/.zshrc",
  }
  secrets = (
    f"{HOME}/.kdbx.kdbx",
    f"{HOME}/.ssh/github",
  )

if __name__ == "__main__":
  for name, dest in dotfiles.items():
    src = os.path.join(BASE_DIR, name)
    if not os.path.exists(src): continue
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.copy(src, dest)
    print(f"copied -> {dest}")

  sm.decrypt_secrets()
  for dest in secrets:
    src = os.path.join(sm.SECRETS_DIR, os.path.basename(dest))
    if not os.path.exists(src): continue
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.copy(src, dest)
    print(f"copied -> {dest}")
  shutil.rmtree(sm.SECRETS_DIR)
  print(f"deleted: {sm.SECRETS_DIR}")

  print("Done!")

