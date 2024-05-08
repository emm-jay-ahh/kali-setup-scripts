#!/bin/bash

if [ -z "$1" ]; then
    echo "Please provide a network adapter name as an argument." >&2
    exit 1
fi

if command -v ip > /dev/null 2>&1; then
    MYIP=$(ip addr show $1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
elif command -v ifconfig > /dev/null 2>&1; then
    MYIP=$(ifconfig $1 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
else
    echo "Neither ip nor ifconfig command is available." >&2
    exit 1
fi

if [ -z "$MYIP" ]; then
    echo "Failed to obtain MYIP address for the adapter: $1" >&2
    exit 1
fi

echo "export MYIP='$MYIP'"
