#!/bin/sh

fetchmail -kv -m "/usr/bin/procmail -d %T"
