#!/bin/bash

set -e

# === INPUT ===
remoteHost="$1"
artifactLocalPath="$2" # Adjust path if needed
remoteAppPath="$3" # /home/WebSites/$(Environment.Name)/$(NginxSiteName)/$(Build.BuildNumber)

# === VARIABLES ===
artifact="movies.zip"
remoteUser="razumovsky_r"
remoteScriptPath="/tmp/SSH-Deploy-Remote.sh"

echo ">>> Copying artifact to remote VM..."
scp "$artifactLocalPath" "$remoteUser@$remoteHost:$3"

echo ">>> Copying deployment script to remote VM..."
scp deploy_remote.sh "$remoteUser@$remoteHost:$remoteScriptPath"

echo ">>> Running deployment script on remote VM..."
ssh "$remoteUser@$remoteHost" "chmod +x $remoteScriptPath && sudo $remoteScriptPath /tmp/$artifact"

echo "✅ Remote deployment finished."
