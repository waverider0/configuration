#!/usr/bin/env python3

import os, sys, shutil
import secret_manager

HOME = os.path.expanduser('~')
REPO = os.path.dirname(os.path.abspath(__file__))

file_map = dict()

if sys.platform.startswith('linux'):
	file_map[f'{REPO}/dotfiles/.gitconfig']             = f'{HOME}/.gitconfig'
	file_map[f'{REPO}/dotfiles/.ssh/config']            = f'{HOME}/.ssh/config'
	file_map[f'{REPO}/dotfiles/.ssh/github.pub']        = f'{HOME}/.ssh/github.pub'
	file_map[f'{REPO}/dotfiles/.tmux.conf']             = f'{HOME}/.tmux.conf'
	file_map[f'{REPO}/dotfiles/.vimrc']                 = f'{HOME}/.vimrc'
	file_map[f'{REPO}/dotfiles/opencode/AGENTS.md']     = f'{HOME}/.config/opencode/AGENTS.md'
	file_map[f'{REPO}/dotfiles/opencode/opencode.json'] = f'{HOME}/.config/opencode/opencode.json'
	file_map[f'{REPO}/secrets/.kdbx.kdbx']              = f'{HOME}/.kdbx.kdbx'
	file_map[f'{REPO}/secrets/.ssh/github']             = f'{HOME}/.ssh/github'

elif sys.platform.startswith('win'):
	file_map[f'{REPO}/dotfiles/.gitconfig']      = f'{HOME}/.gitconfig'
	file_map[f'{REPO}/dotfiles/.ssh/config']     = f'{HOME}/.ssh/config'
	file_map[f'{REPO}/dotfiles/.ssh/github.pub'] = f'{HOME}/.ssh/github.pub'
	file_map[f'{REPO}/dotfiles/.vimrc']          = f'{HOME}/.vimrc'
	file_map[f'{REPO}/secrets/.kdbx.kdbx']       = f'{HOME}/.kdbx.kdbx'
	file_map[f'{REPO}/secrets/.ssh/github']      = f'{HOME}/.ssh/github'

else:
	raise NotImplementedError(f'{sys.platform} is not supported')

if __name__ == '__main__':
	secret_manager.decrypt_secrets()

	for src, dest in file_map.items():
		if not os.path.exists(src): continue
		shutil.copy2(src, dest)
		print(f'copied -> {dest}')

	shutil.rmtree(secret_manager.SECRETS_DIR)
	print(f'deleted: {secret_manager.SECRETS_DIR}')
	print('Done!')
