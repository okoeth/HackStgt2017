#!/bin/bash

if [ x = x$1 -o x = x$2 -o x = x$3 ]; then
    echo "Usage: ./createApp.sh "
    echo "           <namespace>"
    echo "           <app>"
    echo "           <git-url>"
    echo "           <env>"
    exit
fi

NAMESPACE=$1
APP=$2
GIT_URL=$3

if [ x = x$4 ]; then
  ENV=
else
  ENV="-$4"
fi
echo "Using environment: $ENV"

echo "Create PostgreSQL"
oc create -f postgres.yml

echo "Create app"
oc new-app $GIT_URL \
  --strategy=docker \
  --name ${APP}$ENV -n $NAMESPACE

echo "Patch build"
./patchBuild.sh ${APP}$ENV

echo "Patch deploy"
./patchDeploy.sh ${APP}$ENV

echo "Start build"
oc start-build ${APP}$ENV -F

echo "Create route"
oc create -f route.yml
URL=$(oc get route starter-java -o jsonpath="{.spec.host}")
echo "Visit https://$URL"