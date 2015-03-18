This script will download a zip archive containing the latest version of the Slack app for OS X and install it by placing the app extracted from the downloaded archive in the /Applications directory.

How the script works:

1. Uses curl to download a zip archive containing the latest Slack app from OS X from the Slack website into the /tmp directory.

2. Extracts the zip contents in /tmp.

3. Checks whether Slack is running, removes existing Slack app, moves new Slack app from /tmp to /Applications and sets the owner to root:admin

4. Removes the Slack app zip from the /tmp
