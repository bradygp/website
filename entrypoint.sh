#!/bin/sh
set -e

stderr() {
    msg="\e[31m$1\e[0m"
    >&2 echo -e $msg;
}

export GATSBY_DIR="/site"
export PATH="$PATH:/usr/local/bin/gatsby"

if [[ -z "$GATSBY_ENV" ]]
then
    stderr "GATSBY_ENV is not set"
    return 1
fi

if [ ! -f "$GATSBY_DIR/package.json" ]
then
    echo "Initializing Gatsby..."
    if [[ -z "$GIT_REPO" ]]
    then
        gatsby new $GATSBY_DIR
    else
        gatsby new $GATSBY_DIR $GIT_REPO
    fi
fi

if [ ! -e "$GATSBY_DIR/node_modules/" ]
then
    echo "Node modules is empty. Running npm install..."
    npm install
fi

# Decide what to do
if  [ "$GATSBY_ENV" == "develop" ]
then
    rm -rf $GATSBY_DIR/public
    gatsby develop --https --host 0.0.0.0

elif  [ "$GATSBY_ENV" == "build" ]
then
    rm -rf $GATSBY_DIR/public
    gatsby build

elif  [ "$GATSBY_ENV" == "stage" ]
then
    rm -rf $GATSBY_DIR/public
    gatsby build
    gatsby serve --port 8000
else
    stderr "GATSBY_ENV is set to an unknown value '$GATSBY_ENV'"
fi
