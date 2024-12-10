#!/bin/bash

ls /home/groups/STAT_DSCP/Group6/Flight | head -n 450 | sed -s "s|.csv||" > csv_list
