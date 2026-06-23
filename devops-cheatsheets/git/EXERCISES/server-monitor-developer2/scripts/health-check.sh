#!/bin/bash

echo "Checking server health..."
uptime
free -h
df -h
echo "Check time: $(date)"
echo "Disk usage:"
df -h /
