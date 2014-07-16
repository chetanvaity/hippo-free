#!/bin/bash

# There are 10 items and 3 operation theaters (locations)

ITEM_NAME=( Anaesthesia_Machine Dressing_Scissor_1 Fine_Scissor_1 Heart_Lung_Machine Dressing_Scissor_2 Fine_Scissor_2 Resuscitation_Kit Pneumatic_Ventilator Dressing_Scissor_3 Fine_Scissor_3)

# Each item has a home location (OT)

HOME_LOC=( 1 1 1 2 2 2 3 3 3 3 )
HOME2_LOC=( 2 2 2 3 3 3 1 1 1 1 )
HOME3_LOC=( 3 3 3 1 1 1 2 2 2 2 )

# A random number between 0 and 9 to select item
ITEM_ID=$[ ( $RANDOM % 10 ) ]

# Another random number between 0 to 9 to select location
# 0 to 7 means home location, 8 and 9 means other 2 locations
LOC_SELECTOR=$[ ( $RANDOM % 10 ) + 1 ]

LOCATION_ID=${HOME_LOC[$ITEM_ID]}
if (( $LOC_SELECTOR == 8 )); then
    LOCATION_ID=${HOME2_LOC[$ITEM_ID]}
fi
if (( $LOC_SELECTOR == 9 )); then
    LOCATION_ID=${HOME3_LOC[$ITEM_ID]}
fi

# field1 = item id
# field2 = item name
# field3 = item's home location
# field4 = item's current location

/usr/bin/GET "http://localhost:3000/update?key=2PI61XNBLH64BLFM&field1=$ITEM_ID&field2=${ITEM_NAME[$ITEM_ID]}&field3=${HOME_LOC[$ITEM_ID]}&field4=$LOCATION_ID"
