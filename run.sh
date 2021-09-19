#! /bin/sh

set -e

init() {
    git config pull.rebase false

    if [ -n "${COMMITER_NAME}" ]; then
        if [ -z "${COMMITER_EMAIL}" ]; then
            echo "if COMMITER_NAME is set then COMMITER_EMAIL must be set as well"
            exit 1
        fi

        git config user.name "$COMMITER_NAME"
        git config user.email "$COMMITER_EMAIL"
    fi

    git remote add origin "$CLONEPATH"
}


sync_repo() {
    if [ -z "$(git status --short)" ]; then
        echo "Mo changes in files..."
        return
    fi
    if [ ! -f /creds ]; then
       if [ -n "$CREDENTIALS" ]; then
         git config credential.helper "store --file /creds"
         echo "$CREDENTIALS" > /creds
       else
         echo "Missing credentials..."
         exit 1 
       fi

    fi

    git add .
    git commit -m "Automatic commit at $(date)"
    git pull --strategy-option=ours --no-edit
    git push origin master
}

echo "Start sync script with $1 ..."
cd /wiki
if [ $1 == "--init" ]; then
   init
   echo "Git init complete..."
   exit 0
elif [ $1 == "--single" ]; then
   sync_repo
   exit 0
elif [ $1 == "--cyclic" ]; then
  while true; do
    echo "Waiting ${PERIOD:-5m}"
    sleep ${PERIOD:-5m} && sync_repo
  done
fi

