#!/bin/bash

# A random number betweek 0 to 100
VALUE=$[ ( $RANDOM % 100 )  + 1 ]
/usr/bin/GET "http://localhost:3000/update?key=S0RBRR8HBKX3DRPO&field1=$VALUE"
