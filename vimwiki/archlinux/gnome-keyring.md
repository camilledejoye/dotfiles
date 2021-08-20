# Gnome Keyring

[ArchLinux artcile](https://wiki.archlinux.org/title/GNOME/Keyring)

## Installation

```sh
ysy -S gnome-keyring libsecret seahorse secret-tool
```

## Start the deamon

Using XDG autostart files present in the dotfiles.
See the Archlinux wiki for more information.

But the necessary environment variables are not defined this way so we also
need to export them manually in `~/.shell/env`:

```sh
# Gnome keyring as SSH agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
export SSH_ASKPASS=/usr/lib/seahorse/ssh-askpass
```

## Using as GPG agent

Define the pinentry program in the file `~/.gnupg/gpg-agent.conf`:

```
pinentry-program /usr/bin/pinentry-gnome3
```

## Git integration

The configuration from the dotfiles already include it, but if needed you can run:

```sh
git config --global credential.helper /usr/lib/git-core/git-credential-libsecret
```
