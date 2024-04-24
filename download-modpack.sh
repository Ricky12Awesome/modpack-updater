#!/usr/bin/env sh

CACHE_PATH="latest_filename_cache.txt"
CACHE=""

if [[ -z $AUTO_DELETE ]]; then
  AUTO_DELETE="true"
fi

if [[ -z $FORCE_UNPACK ]]; then
  FORCE_UNPACK="false"
fi

if [[ -f $CACHE_PATH ]]; then
  CACHE=$(cat $CACHE_PATH)
fi

unpack() {
  echo Unpacking $fileName...
  unzip -uo $fileName -d .

  folder=${fileName%.*}

  if [[ -d "$folder" ]]; then
    echo "Copying ./$folder to $PWD..."
    # Can't use mv because "Directory not empty"
    cp -urf $folder/* .
    echo "Deleting ./$folder..."
    rm -rf $folder
  fi
}

download() {
  echo $fileName >$CACHE_PATH

  if ! [[ -z $downloadUrl ]]; then
    echo Downloading $fileName...
    wget $downloadUrl
  fi

  unpack

  if [[ $AUTO_DELETE == "true" ]]; then
    echo Deleting $fileName...
    rm -f $fileName
  fi

  echo "Finished"
}

if [[ -f "force-update.zip" ]]; then
  fileName="force-update.zip"
  download
  exit
fi

if [[ $FORCE_UNPACK == "true" && -f "$CACHE" ]]; then
  fileName="$CACHE"
  unpack
  exit
fi

HEADERS="x-api-key: $CF_API_KEY"
URL="https://api.curseforge.com/v1/mods/$CF_PROJECT_ID"

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

if [ "$CACHE" = "$fileName" ]; then
  echo Skipping $fileName already on version
  echo to force a download, delete $CACHE_PATH

  exit
fi

download
