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
appends = {
}
secrets = (
  f'{HOME}/.kdbx.kdbx',
  f'{HOME}/.ssh/github',
)

if sys.platform.startswith('linux'):
  dotfiles['nvim/init.lua']           = f'{HOME}/.config/nvim/init.lua'
  dotfiles['tmux/tmux.conf']          = f'{HOME}/.tmux.conf'
  dotfiles['vscode/keybindings.json'] = f'{HOME}/.config/VSCodium/User/keybindings.json'
  dotfiles['vscode/settings.json']    = f'{HOME}/.config/VSCodium/User/settings.json'
  dotfiles['zsh/zshrc']               = f'{HOME}/.zshrc'
  appends['hypr/hyprland.conf']       = f'{HOME}/.config/hypr/hyprland.conf'
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

  for source, dest in appends.items():
    src = os.path.join(DOTFILES_DIR, source)
    with open(src, 'r') as s, open(dest, 'a+') as d:
      new = s.read()
      d.seek(0)
      if new not in d.read(): d.write(new)
      print(f'appended -> {dest}')

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

