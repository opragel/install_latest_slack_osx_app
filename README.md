This script will download a zip archive containing the latest version of Slack and install Slack by placing the app extracted from the downloaded archive in the Applications directory.

How the script works:

1. Uses curl to download a zip archive containing the latest Slack app from OS X from the Slack website

2. Stores the Slack app zip in /tmp

3. Extracts the zip contents to /tmp. Normal use does not require user to inspect the /tmp

4. Moves the Slack app from /tmp to /Applications and sets the owner to root:admin

5. Removes the Slack app zip from /tmp
