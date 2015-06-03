#!/usr/bin/env bash

# Downloads and installs the latest version of Slack for OS X

printf "Slack auto-install script for OS X\n\n"

SLACK_DOWNLOAD_URL="https://slack.com/ssb/download-osx"
SLACK_10_6_DOWNLOAD_URL="https://slack.com/ssb/download-osx-10-6"

SLACK_ZIP_PATH="/tmp/Slack.app.zip"
SLACK_UNZIP_DIRECTORY="/tmp"
SLACK_APP_UNZIPPED_PATH="/tmp/Slack.app/"
SLACK_APP_PATH="/Applications/Slack.app/"
SLACK_RELATIVE_INFO_PLIST="Contents/Info.plist"

# OS X major release version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

if [ "$osvers" -lt 6 ]; then
  printf "Slack is not available for Mac OS X 10.5.8 or earlier\n"
else
  rm -rf "$SLACK_ZIP_PATH" "$SLACK_APP_UNZIPPED_PATH"
  if [ "$osvers" -lt 7 ]; then
    printf "Downloading Slack for Mac OS X 10.6.8\n"
    /usr/bin/curl --retry 3 -L "$SLACK_10_6_DOWNLOAD_URL" -o "$SLACK_ZIP_PATH"
  else
    printf "Downloading Slack for Mac OS X 10.7.5 and later\n"
    /usr/bin/curl --retry 3 -L "$SLACK_DOWNLOAD_URL" -o "$SLACK_ZIP_PATH"
  fi
  /usr/bin/unzip -q "$SLACK_ZIP_PATH" -d "$SLACK_UNZIP_DIRECTORY"
  if pgrep 'Slack'; then
    printf "Error: Slack is currently running!\n"
  else
    if [ -d "$SLACK_APP_PATH" ]; then
      slackVersion=$(defaults read "$SLACK_APP_PATH$SLACK_RELATIVE_INFO_PLIST" CFBundleShortVersionString)
      printf "Removing Slack version %s\n" "$slackVersion"
      rm -rf "$SLACK_APP_PATH"
    fi
    mv -f "$SLACK_APP_UNZIPPED_PATH" "$SLACK_APP_PATH"
    chown -R root:wheel "$SLACK_APP_PATH"
    slackVersion=$(defaults read "$SLACK_APP_PATH$SLACK_RELATIVE_INFO_PLIST" CFBundleShortVersionString)
    printf "Installed Slack version %s\n" "$slackVersion"
    rm -f "$SLACK_ZIP_PATH" "$SLACK_APP_UNZIPPED_PATH"
  fi
fi
printf "Exiting...\n"
exit 0
