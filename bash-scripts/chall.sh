#!/usr/bin/bash

# loop from 1 to 100
for i in {1..100}
do
    # count the value in here
    odd_number=`expr $i % 2`;
    # check if the value is 1 that means odd 
    if [ $odd_number != 0 ]; then
        echo $i
    fi
done
