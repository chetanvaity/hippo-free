#!/bin/bash

VALUE=`cat /proc/meminfo | grep MemFree | awk '{print $2}'`
/usr/bin/GET "http://localhost:3000/update?key=N8DB7EVMNHVNWEPP&field1=$VALUE"
