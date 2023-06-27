FROM ubuntu:22.04

ENV JAVA_HOME /opt/jdk
ENV PATH $JAVA_HOME/bin:$PATH

ADD "https://cdn.azul.com/zulu/bin/zulu17.42.21-ca-crac-jdk17.0.7-linux_x64.tar.gz" $JAVA_HOME/openjdk.tar.gz
RUN tar --extract --file $JAVA_HOME/openjdk.tar.gz --directory "$JAVA_HOME" --strip-components 1; rm $JAVA_HOME/openjdk.tar.gz;

RUN apt-get update && apt-get install ca-certificates curl apt-transport-https lsb-release gnupg -y
RUN mkdir -p /etc/apt/keyrings && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null && chmod go+r /etc/apt/keyrings/microsoft.gpg
RUN AZ_REPO=$(lsb_release -cs) && echo "deb [arch=`dpkg --print-architecture` signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install azure-cli -y

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-$(lsb_release -cs)-prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-get update && apt-get install azure-functions-core-tools-4 -y

RUN mkdir -p /opt/app
# COPY target/file-split-ftp-6.0.0.jar /opt/app/file-split-ftp-6.0.0.jar
RUN mkdir -p /opt/crac-files

COPY src/scripts/entrypoint-checkpoint.sh /opt/app/entrypoint-checkpoint.sh
COPY src/scripts/entrypoint-restore.sh /opt/app/entrypoint-restore.sh

ADD . .

RUN ./mvnw clean package

ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1

# ENTRYPOINT /opt/app/entrypoint-checkpoint.sh
