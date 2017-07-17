#!/bin/bash
echo 'migrating github private repositories to aws codecommit'
echo 'this script requires gh (npm i -g gh) and aws-cli (brew install aws-cli)'
echo 'usage: ./start.sh <username> <codecommit url: git-codecommit.ap-northeast-2.amazonaws.com>'
USERNAME=$1
CODECOMMIT=$2
CWD=$(pwd)

gh us
gh re -l -t private -u stunitas | grep $USERNAME > list.txt
cat list.txt | \
  while read REPO; do
    ONLY_REPO=$(cut -d "/" -f 2 <<< "$REPO")
    git clone git@github.com:$REPO
    cd $ONLY_REPO
    git remote add codecommit ssh://${CODECOMMIT}/v1/repos/$ONLY_REPO
    aws codecommit create-repository --repository-name $ONLY_REPO
    git push codecommit --all
    cd $CWD
  done
