#!/bin/bash

# PUPPET PUT ME HERE
# Quick and dirty script for checking for a mysql user and returning a 0 / non-zero status code for use in puppet manifests

RCOUNT=`mysql -u root -AN -e "SELECT COUNT(1) FROM mysql.user WHERE user = '$1' AND host = '$2'"`
if [ ${RCOUNT} -eq 0 ]
then
    exit 1
else
    exit 0
fi