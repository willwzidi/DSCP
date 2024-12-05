#!/bin/bash

ls /home/groups/STAT_DSCP/Group6/flight | head -n 100 | sed -s "s|.csv||" > csv_list
