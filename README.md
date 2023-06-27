# azure-crack-demo
```
docker  build -f ./Dockerfile -t tzolov/scf-az-crac:builder .
```

```
docker run -it --privileged --rm --name=azure-crac-demo --ulimit nofile=1024 -p 7072:7072 tzolov/scf-az-crac:builder /bin/bash
```
and form the same container start the function:
```
export MAVEN_OPTS="-XX:CRaCCheckpointTo=/opt/crac-files"
echo 128 > /proc/sys/kernel/ns_last_pid; ./mvnw azure-functions:run&
```


After the application is warmed up, use `jcmd` to trigger the checkpoint creation:
```
jcmd /usr/lib/azure-functions-core-tools-4/workers/java/azure-functions-java-worker.jar JDK.checkpoint
```

Alternatively you can run the jcmd in a separate terminal:
```
docker exec -it  --privileged -u root azure-crac-demo jcmd /usr/lib/azure-functions-core-tools-4/workers/java/azure-functions-java-worker.jar JDK.checkpoint
```

You will see exception like:
```
An exception during a checkpoint operation:
jdk.internal.crac.CheckpointException
	at java.base/jdk.internal.crac.Core.checkpointRestore1(Core.java:122)
	at java.base/jdk.internal.crac.Core.checkpointRestore(Core.java:246)
	at java.base/jdk.internal.crac.Core.checkpointRestoreInternal(Core.java:262)
	Suppressed: java.nio.channels.IllegalSelectorException
		at java.base/sun.nio.ch.EPollSelectorImpl.beforeCheckpoint(EPollSelectorImpl.java:384)
		at java.base/jdk.internal.crac.impl.AbstractContextImpl.beforeCheckpoint(AbstractContextImpl.java:66)
		at java.base/jdk.internal.crac.impl.AbstractContextImpl.beforeCheckpoint(AbstractContextImpl.java:66)
		at java.base/jdk.internal.crac.Core.checkpointRestore1(Core.java:120)
		... 2 more
	Suppressed: java.lang.RuntimeException: C/R is not configured
		at java.base/jdk.internal.crac.Core.checkpointRestore1(Core.java:148)
		... 2 more
```

