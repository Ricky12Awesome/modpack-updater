#!/usr/bin/env sh

CACHE_PATH="latest_filename_cache.txt"
CACHE=$(cat $CACHE_PATH 2>/dev/null || echo "")
HEADERS="x-api-key: $CF_API_KEY"
URL="https://api.curseforge.com/v1/mods/$CF_PROJECT_ID"

download() {
  echo $fileName >$CACHE_PATH

  if ! [[ -z $downloadUrl ]]; then
    echo Downloading $fileName...
    wget $downloadUrl
  fi

  echo Unpacking $fileName...
  unzip -fo $fileName -d .

  echo Deleting $fileName...
  rm -f $fileName

  echo "Finished"
}

if [[ -f "force-update.zip" ]]; then
  fileName="force-update.zip"
  download
  exit
fi

mainFileId=$(curl -sH "$HEADERS" $URL | jq ".data.mainFileId")
serverPackFileId=$(curl -sH "$HEADERS" $URL/files/$mainFileId | jq ".data.serverPackFileId")

if [ $serverPackFileId = "null" ]; then
  echo "Server files doesn't exist"
  echo "most likely that the author hasn't uploaded it yet."
  exit
fi

manifest=$(curl -sH "$HEADERS" $URL/files/$serverPackFileId)
# displayName=$(echo $manifest | jq -r ".data.displayName")
fileName=$(echo $manifest | jq -r ".data.fileName")
downloadUrl=$(echo $manifest | jq -r ".data.downloadUrl")

if [ $(cat $CACHE_PATH) = $fileName ]; then
  echo Skipping $fileName already on version
  echo to force a download, delete $CACHE_PATH

  exit
fi

download