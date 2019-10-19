if ! type 'prompt_install' >/dev/null 2>&1; then
    THIS_DIR="$( cd "$( dirname "$0" )" ; pwd -P )"
    . "$THIS_DIR/../lib.sh"
fi

install_bat() {
    echo "Fetching last version of bat..."

    BAT_URL=`curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep 'browser_download_url.*bat_.*_amd64.deb' | cut -d: -f2,3 | tr -d \"\ `
    BAT_BIN="/tmp/$(basename "$BAT_URL")"

    echo "Downloading $(basename $BAT_BIN):"
    wget -q --show-progress --progress=bar:force -P "$(dirname $BAT_BIN)" -q "$BAT_URL"

    echo "Installing bat:"
    sudo dpkg -i "$BAT_BIN"

    echo "bat is now installed."
    rm -fr "$BAT_BIN"
}

check_install_bat() {
    if ! [ -x "$(command -v bat)" ]; then
        answer=$( ask_for_yes_or_no "bat is not installed, would you like to install it?" )

        if echo "$answer" | grep -iq "^y" ;then
            install_bat
        fi
    else
        echo "bat is already installed, nothing to do."
    fi
}

check_install_bat
