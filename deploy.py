#!/usr/bin/env python3

import os, shutil
import secret_manager

HOME = os.path.expanduser("~")
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

dotfiles = {
  "dotfiles/.gitconfig": f"{HOME}/.gitconfig",
  "dotfiles/github.pub": f"{HOME}/.ssh/github.pub",
  "dotfiles/ssh_config": f"{HOME}/.ssh/config",
}

secrets = (
  f"{HOME}/.kdbx.kdbx",
  f"{HOME}/.ssh/github",
)

if os.name == "nt":
  dotfiles["dotfiles/vscode_keybindings.json"] = f"{HOME}/AppData/Roaming/VSCodium/User/keybindings.json"
  dotfiles["dotfiles/vscode_settings.json"]    = f"{HOME}/AppData/Roaming/VSCodium/User/settings.json"
  dotfiles["dotfiles/windows/startup.bat"]     = "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup/startup.bat" # requires admin
elif os.name == "posix":
  dotfiles["dotfiles/nvim_init.lua"]            = f"{HOME}/.config/nvim/init.lua"
  dotfiles["dotfiles/vscode_keybindings.json"]  = f"{HOME}/.config/VSCodium/User/keybindings.json"
  dotfiles["dotfiles/vscode_settings.json"]     = f"{HOME}/.config/VSCodium/User/settings.json"
  dotfiles["dotfiles/unix/.tmux.conf"]          = f"{HOME}/.tmux.conf"
  dotfiles["dotfiles/unix/.zshrc"]              = f"{HOME}/.zshrc" # chsh -s /bin/zsh
  #dotfiles["dotfiles/unix/linux/rofi"]          = f"{HOME}/.config/rofi/config.rasi"
  #dotfiles["dotfiles/unix/linux/hyprland.conf"] = f"{HOME}/.config/hypr/hyprland.conf"
else:
  raise NotImplementedError(f"{os.name} is not supported")

if __name__ == "__main__":
  for name, dest in dotfiles.items():
    src = os.path.join(BASE_DIR, name)
    if not os.path.exists(src): continue
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.copy(src, dest)
    print(f"copied -> {dest}")

  secret_manager.decrypt_secrets()
  for dest in secrets:
    src = os.path.join(secret_manager.SECRETS_DIR, os.path.basename(dest))
    if not os.path.exists(src): continue
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.copy(src, dest)
    print(f"copied -> {dest}")
  shutil.rmtree(secret_manager.SECRETS_DIR)
  print(f"deleted: {secret_manager.SECRETS_DIR}")

  print("Done!")

