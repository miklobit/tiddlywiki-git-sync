#! /bin/sh

set -e

init()
    if [ -f /creds ]; then
        return
    fi
    git config pull.rebase false

    if [ -n "${COMMITER_NAME}" ]; then
        if [ -z "${COMMITER_EMAIL}" ]; then
            echo "if COMMITER_NAME is set then COMMITER_EMAIL must be set as well"
            exit 1
        fi

        git config user.name "$COMMITER_NAME"
        git config user.email "$COMMITER_EMAIL"
    fi

    if [ -n "$CREDENTIALS" ]; then
        git config credential.helper "store --file /creds"
        echo "$CREDENTIALS" > /creds
    fi

    git remote add origin "$CLONEPATH"
}


sync_repo() {
    if [ -z "$(git status --short)" ]; then
        echo "Mo changes in files..."
        return
    fi
    git add .
    git commit -m "Automatic commit at $(date)"
    git pull --strategy-option=ours --no-edit
    git push origin master
}

echo "Start sync script..."
init
cd /wiki
while true; do
    sleep ${PERIOD:-5m} && sync_repo
done
