#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace 

function isAppOpen {
    wmctrl -l -x | grep -i -q "${APP_NAME}"
}

function focusApp {
    local windowId="$(wmctrl -l -x | grep -i "${APP_NAME}" | awk '{print $1}' | head -n1)"
    wmctrl -i -a "${windowId}"
}

function isFlatpakApp {
    flatpak list | grep -i -q "${APP_NAME}"
}

function getFlatpakAppId {
    flatpakAppId="$(flatpak list | grep -i "${APP_NAME}" | awk -F"\t" '{print $2}')"
}

APP_NAME=$1
if isAppOpen; then
    focusApp
else
    if isFlatpakApp; then
        getFlatpakAppId
        flatpak run "${flatpakAppId}"
    else
        "${APP_NAME}" || gtk-launch ${APP_NAME} || "${APP_NAME}"
    fi
fi
