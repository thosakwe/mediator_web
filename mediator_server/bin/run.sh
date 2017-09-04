#!/usr/bin/env bash
dname="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $dname/..
sudo -E dart bin/force_https.dart &
sudo -E dart bin/server.dart &
