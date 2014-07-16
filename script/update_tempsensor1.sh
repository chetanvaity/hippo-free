#!/bin/bash

# A random number betweek 0 to 35
VALUE=$[ ( $RANDOM % 35 )  + 1 ]
TEMP=$[ -50 + $VALUE ]
/usr/bin/GET "http://localhost:3000/update?key=U9G6KKSQDF3X5VA3&field1=$TEMP&field2=1"
