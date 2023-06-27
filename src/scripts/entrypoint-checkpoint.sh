#!/bin/bash

export MAVEN_OPTS="-XX:CRaCCheckpointTo=/opt/crac-files"
echo 128 > /proc/sys/kernel/ns_last_pid; ./mvnw azure-functions:run&
sleep 20
jcmd
echo " Now "
jcmd /usr/lib/azure-functions-core-tools-4/workers/java/azure-functions-java-worker.jar JDK.checkpoint
sleep infinity
