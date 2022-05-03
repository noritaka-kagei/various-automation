#!/bin/sh

# This script check environment is ready.
# Return following exit code
#   0: environment is ready
#   1: command (cli) is not found
#   2: file defined by configuration file is not found

# load implemented function
. utility_function.sh

# 1. check command(cli) environment
echo "\n*** Checking environment for executing Unit-Test ***\n"
## 1.1. JDK
if java -version > /dev/null 2>&1; then
    SuccessCommandCheck "JDK"
else
    FailCommandCheck "java"
fi

## 1.2. Golang
if go version > /dev/null 2>&1; then
    SuccessCommandCheck "Go"
else
    FailCommandCheck "go"
fi

## 1.3. container (podman or docker)
if docker version > /dev/null 2>&1; then
    SuccessCommandCheck "Container(Docker)"
elif podman version > /dev/null 2>&1; then
    SuccessCommandCheck "Container(Podman)"
else
    FailCommandCheck "docker/podman"
fi

status=$(ColoringStatus "SUCCESS")
printf "\n*** [%s] Checking environment for executing Unit-Test ***\n\n" $status


# 2. check file environment defined by configuration file
## 2.1. configuration file defined file path
if [ -e test.conf ]; then
    echo "\n*** Reading configration file to test ***\n"
    . ./test.conf # load variable of test.conf
    status=$(ColoringStatus "OK")
    printf "[%s] checking test.conf\n" $status
else
    echo "[ERROR] test.conf is not found."
    exit 2
fi

## 2.2. check whether JDK8 installer file exists
if [ -e ${JDK8InstallerFile} ]; then
    SuccessInstallerFileCheck "JDK8" ${JDK8InstallerFile}
else
    FailInstallerFileCheck "JDK8" ${JDK8InstallerFile}
fi

## 2.3. check whether JDK11 installer file exists
if [ -e ${JDK11InstallerFile} ]; then
    SuccessInstallerFileCheck "JDK11" ${JDK11InstallerFile}
else
    FailInstallerFileCheck "JDK11" ${JDK11InstallerFile}
fi

## 2.4. check whether JDK17 installer file exists
if [ -e ${JDK17InstallerFile} ]; then
    SuccessInstallerFileCheck "JDK17" ${JDK17InstallerFile}
else
    FailInstallerFileCheck "JDK17" ${JDK17InstallerFile}
fi

## 2.5. check whether Maven installer file exists
if [ -e ${MavenInstallerFile} ]; then
    SuccessInstallerFileCheck "Maven" ${MavenInstallerFile}
else
    FailInstallerFileCheck "Maven" ${MavenInstallerFile}
fi

## 2.6. check whether Maven repository (.m2) directory exists
M2Dir="${MavenRepositoryDirectory}/.m2"
if [ -e $M2Dir ]; then
    if status=$(ColoringStatus "OK"); then
        printf "[%s] Maven repository (.m2)\n" $status
    else
        exit 99
    fi
else
    if status=$(ColoringStatus "ERROR"); then
        printf "[%s] Not found .m2 directory in maven repository: %s\n" $status $M2Dir
        exit 2
    else
        exit 99
    fi
fi

status=$(ColoringStatus "SUCCESS")
printf "\n*** [%s] Reading configration file to test ***\n\n" $status