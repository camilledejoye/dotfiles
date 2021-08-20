# Docker

## Installation

```sh
pacman -S docker
```

Start and enable docker service:
```sh
systemctl enable --now docker
```

To run docker commands as non root:
```sh
usermod -aG docker $USER
```

You'll need to logout and log back in for this to take effect.

## Using pass as a credentials helper

For maximum security a credentials helper should be used, otherwise the credentials will be stored in clear in the docker configuration file.

First install the helper:
```sh
yay -S docker-credentials-pass
```

Then configure the helper in the `~/.docker/config.json` file:
```json
{
	"credsStore": "pass"
}
```

Login a first time and enter your credentials, example for Wynd:
```sh
docker login https://docker-push.wynd.eu
```

In order to reuse a password arleady in the password store for the first login:
```sh
pass wynd/ldap/camille.dejoye | docker login -u camille.dejoye --password-stdin https://docker-push.wynd.eu
```

To check that the store is working try to login again without credentials:
```sh
docker login https://docker-push.wynd.eu
```

## Using the Gnome keyring as a credentials helper

For maximum security a credentials helper should be used, otherwise the credentials will be stored in clear in the docker configuration file.

First install the helper:
```sh
yay -S docker-credentials-secretservice
```

Then configure the helper in the `~/.docker/config.json` file:
```json
{
	"credsStore": "secretservice"
}
```

Login a first time and enter your credentials, example for Wynd:
```sh
docker login https://docker-push.wynd.eu
```

In order to reuse a password arleady in the password store for the first login:
```sh
pass wynd/ldap/camille.dejoye | docker login -u camille.dejoye --password-stdin https://docker-push.wynd.eu
```

To check that the store is working try to login again without credentials:
```sh
docker login https://docker-push.wynd.eu
```
