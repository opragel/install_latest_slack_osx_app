#!/bin/bash
# your funeral
# seriously use autopkg or something

DOWNLOAD_URL="https://slack.com/ssb/download-osx"

APP_NAME="Slack.app"
APP_PATH="/Applications/$APP_NAME"
APP_VERSION_KEY="CFBundleShortVersionString"

SLACK_UNZIP_DIRECTORY="/tmp"
SLACK_APP_UNZIPPED_PATH="/tmp/Slack.app/"

currentSlackVersion=$(curl -s 'https://downloads.slack-edge.com/mac_releases/releases.json' | grep -o "[0-9]\.[0-9]\.[0-9]" | tail -1)

if [ -d "$APP_PATH" ]; then
    localSlackVersion=$(defaults read "$APP_PATH/Contents/Info.plist" "$APP_VERSION_KEY")
    if [ "$currentSlackVersion" = "$localSlackVersion" ]; then
        printf "Slack is already up-to-date. Version: %s" "$localSlackVersion"
        exit 0
    fi
fi

# OS X major release version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

if [ "$osvers" -lt 7 ]; then
    printf "Slack is not available for Mac OS X 10.6 or earlier\n"
    exit 403
elif [ "$osvers" -ge 7 ]; then
    finalDownloadUrl=$(curl "$DOWNLOAD_URL" -s -L -I -o /dev/null -w '%{url_effective}')
else
    printf "Unable to read OS version"
    exit 404
fi

zipName=$(printf "%s" "${finalDownloadUrl[@]}" | sed 's@.*/@@')
slackZipPath="/tmp/$zipName"
rm -rf "$slackZipPath" "$SLACK_UNZIP_DIRECTORY"
/usr/bin/curl --retry 3 -L "$finalDownloadUrl" -o "$slackZipPath"
/usr/bin/unzip -q "$slackZipPath" -d "$SLACK_UNZIP_DIRECTORY"
rm -f "$slackZipPath"

if pgrep 'Slack'; then
    printf "Error: Slack is currently running!\n"
    exit 409
else
    if [ -d "$APP_PATH" ]; then
        rm -rf "$APP_PATH"
    fi
    mv -f "$SLACK_APP_UNZIPPED_PATH" "$APP_PATH"
    # Slack permissions are stupid
    chown -R root:admin "$APP_PATH"
    localSlackVersion=$(defaults read "$APP_PATH/Contents/Info.plist" "$APP_VERSION_KEY")
    if [ "$currentSlackVersion" = "$localSlackVersion" ]; then
        printf "Slack is now updated/installed. Version: %s" "$localSlackVersion"
        exit 0
    fi
fi
