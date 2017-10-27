#!/bin/bash
if [ x = x$1 ]; then
    echo "Usage: ./patchDeploy.sh <app> <mem-limit opt.>"
    exit
fi

APP_NAME=$1

if [ x = x$2 ]; then
    echo "Default limit of 512Mi"
    MEM_LIMIT=512Mi
else
    echo "Custom limit of $2"
    MEM_LIMIT=$2
fi

# Patch missing elements in deployment
oc patch dc/$APP_NAME -p '{
    "spec":{
        "strategy":{
            "type":"Recreate"}}}'
oc patch dc/$APP_NAME -p '{
    "spec":{
        "strategy":{
            "resources":{
                "limits":{
                    "memory": "'$MEM_LIMIT'"}}}}}'
oc patch dc/$APP_NAME -p '{
    "spec":{
        "template":{
            "spec":{
                "containers":[{
                    "name":"'$APP_NAME'",
                    "resources":{
                        "limits":{
                            "memory": "'$MEM_LIMIT'"}}}]}}}}'
oc patch dc/$APP_NAME -p '{
    "spec":{
        "template":{
            "spec":{
                "containers":[{
                    "name":"'$APP_NAME'",
                    "env":[
                       { "name": "SPRING_DATASOURCE_URL", "value": "jdbc:postgresql://postgresql:5432/starterjava" },
                       { "name": "SPRING_DATASOURCE_USERNAME", "value": "expenses" },
                       { "name": "SPRING_DATASOURCE_PASSWORD", "value": "S$cr$t" },
                       { "name": "SPRING_JPA_HIBERNATE_DDL_AUTO", "value": "update" }
                    ]}]}}}}'