#!/bin/bash

NB_CPU=$(grep processor /dev/cp | wc -l)

sed s/
