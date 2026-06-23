#!/bin/bash

echo "Checking server health..."
uptime
free -h
df -h
echo "Disk usage:"
df -h  /
