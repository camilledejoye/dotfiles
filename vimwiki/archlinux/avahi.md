# [Avahi](https://wiki.archlinux.org/title/Avahi)

Avahi is a Zero-configuration networking implementation, including a system for mDNS.
Basically it allows to automatically detect hosts on the current local network, including other computers but
also printers, etc.

## Installation

First install Avahi and the `nss-mdns` package which will allow to resolveq local names (like
`cdejoye-mac.local`) to their IP address.

```sh
yay -S avahi nss-mdns
```

Enable the Avahi deamon:
```sh
systemctl enable avahi-daemon
```

## Configuration

The default configuration of Avahi will work by default and use the standard TLD name `local`.
To enable name resolution using mDNS update the configuration file `/etc/nsswitch.conf` and replace the line
starting with `hosts:` by:
```sh
# Default value
# hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
# Only handle .local TLD
hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
# Only handle .local TLD for IP v4 (in case it slow with IP v6)
# hosts: mymachines mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
# to handle custom TLD as well
# hosts: mymachines mdns [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

Start the daemon:
```sh
systemctl start avahi-daemon
```

## Tools

Avahi includes several utilities which help you discover the services running on a network. For example, run:
```sh
avahi-browse --all --ignore-local --resolve --terminate
```
