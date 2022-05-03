#!/bin/sh

# This script define utiliy function
# Return following exit code
#   0:  successfully executing the function
#   1:  command (cli) is not found
#   2:  file defined by configuration file is not found
#   99: unexpected error

## output color message OK/ERROR
ColoringStatus() {
    if [ $1 = "OK" -o $1 = "ok" ]; then
        # blue and BOLD
        printf "\e[36;1mOK\e[m"
    elif [ $1 = "SUCCESS" -o $1 = "success" ]; then
        # green and BOLD
        printf "\e[32;1mSUCCESS\e[m"
    elif [ $1 = "ERROR" -o $1 = "error" ]; then
        # red and BOLD
        printf "\e[31;1mERROR\e[m"
    else
        printf "unexpected argument of ColoringStatus() func.\n"
        exit 99
    fi
}
## output message about environment. if error, exit with status code (=1)
SuccessCommandCheck() {
    if status=$(ColoringStatus "OK"); then
        printf "[%s] %s environment\n" $status $1
    else
        printf $status
        exit 99
    fi
}
FailCommandCheck() {
    if status=$(ColoringStatus "ERROR"); then
        printf "[%s] Not found %s command\n" $status $1
        echo "Please check whether command path is through.\n"
        exit 1        
    else
        printf $status
    fi
}
## output message about installer file. if error, exit with status code (=2)
## arguments: 1st=installer type, 2nd=installer path
SuccessInstallerFileCheck() {
    if status=$(ColoringStatus "OK"); then
        printf "[%s] %s installer file: %s\n" $status $1 $2
    else
        printf $status
        exit 99
    fi
}
FailInstallerFileCheck() {
    if status=$(ColoringStatus "ERROR"); then
        printf "[%s] Not found %s installer file: %s\n" $status $1 $2
        echo "Please check whether file path is correct.\n"
        exit 2
    else
        printf $status
    fi
}
