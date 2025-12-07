#!/usr/bin/env python3

import os, sys, shutil
import secret_manager

HOME = os.path.expanduser('~')
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DOTFILES_DIR = os.path.join(BASE_DIR, 'dotfiles')

dotfiles = {
  'git/.gitconfig': f'{HOME}/.gitconfig',
  'git/github.pub': f'{HOME}/.ssh/github.pub',
  'git/ssh_config': f'{HOME}/.ssh/config',
}

secrets = (
  f'{HOME}/.kdbx.kdbx',
  f'{HOME}/.ssh/github',
)

if sys.platform.startswith('linux'):
  dotfiles['hyprland/hyprland.conf']  = f'{HOME}/.config/hypr/hyprland.conf'
  dotfiles['nvim/init.lua']           = f'{HOME}/.config/nvim/init.lua'
  dotfiles['rofi/config.rasi']        = f'{HOME}/.config/rofi/config.rasi'
  dotfiles['tmux/tmuxconf']           = f'{HOME}/.tmux.conf'
  dotfiles['vscode/keybindings.json'] = f'{HOME}/.config/VSCodium/User/keybindings.json'
  dotfiles['vscode/settings.json']    = f'{HOME}/.config/VSCodium/User/settings.json'
  dotfiles['waybar/config.jsonc']     = f'{HOME}/.config/waybar/config.jsonc'
  dotfiles['waybar/style.css']        = f'{HOME}/.config/waybar/style.css'
  dotfiles['zsh/zshrc']               = f'{HOME}/.zshrc' # chsh -s /bin/zsh
elif sys.platform.startswith('win'):
  dotfiles['vscode/keybindings.json'] = f'{HOME}/AppData/Roaming/VSCodium/User/keybindings.json'
  dotfiles['vscode/settings.json']    = f'{HOME}/AppData/Roaming/VSCodium/User/settings.json'
  dotfiles['windows/startup.bat']     = 'C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup/startup.bat' # requires admin
else:
  raise NotImplementedError(f'{sys.platform} is not supported')

if __name__ == '__main__':
  for source, dest in dotfiles.items():
    src = os.path.join(DOTFILES_DIR, source)
    if not os.path.exists(src): continue
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.copy(src, dest)
    print(f'copied -> {dest}')

  secret_manager.decrypt_secrets()
  for dest in secrets:
    src = os.path.join(secret_manager.SECRETS_DIR, os.path.basename(dest))
    if not os.path.exists(src): continue
    os.makedirs(os.path.dirname(dest), exist_ok=True)
    shutil.copy(src, dest)
    print(f'copied -> {dest}')
  shutil.rmtree(secret_manager.SECRETS_DIR)
  print(f'deleted: {secret_manager.SECRETS_DIR}')

  print('Done!')

