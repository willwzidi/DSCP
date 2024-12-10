#!/bin/bash

ls /home/hwu478/GroupProject/output_rds | head -n 450 | sed -s "s|.rds||" > rds_list
