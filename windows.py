import os, shutil, getpass
from secret.crypto import SALT_FILE, derive_key, decrypt, atomic_write

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

CONFIGS = {
  "config/.gitconfig":          "C:/Users/allen/.gitconfig",
  "config/.vimrc":              "C:/Users/allen/.vimrc",
  "config/github.pub":          "C:/Users/allen/.ssh/github.pub",
  "config/keybindings.json":    "C:/Users/allen/AppData/Roaming/VSCodium/User/keybindings.json",
  "config/settings.json":       "C:/Users/allen/AppData/Roaming/VSCodium/User/settings.json",
  "config/ssh_config":          "C:/Users/allen/.ssh/config",
  "config/windows/startup.bat": "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Startup/startup.bat", # requires admin
}

SECRETS = {
  ".kdbx.kdbx.e": "C:/Users/allen/.kdbx.kdbx",
  "github.e":     "C:/Users/allen/.ssh/github",
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
