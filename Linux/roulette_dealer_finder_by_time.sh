#!/bin/bash

cd Dealer_Schedules_0310/
grep -r '_0\|AM\|PM' * | awk '{print$1,$2,$3,$4,$5,$6,$7,$8}'

