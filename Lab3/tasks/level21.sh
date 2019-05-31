#!/bin/bash
find -name "*[0-9].txt" -delete
find -name "*[a-z].png" -delete
find -type f -name "test*.[!gz]*" -delete
