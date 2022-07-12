# # # Distribution Statement A. Approved for public release. Distribution unlimited.
# # # 
# # # Author:
# # # Naval Research Laboratory, Marine Meteorology Division
# # # 
# # # This program is free software:
# # # you can redistribute it and/or modify it under the terms
# # # of the NRLMMD License included with this program.
# # # 
# # # If you did not receive the license, see
# # # https://github.com/U-S-NRL-Marine-Meteorology-Division/
# # # for more information.
# # # 
# # # This program is distributed WITHOUT ANY WARRANTY;
# # # without even the implied warranty of MERCHANTABILITY
# # # or FITNESS FOR A PARTICULAR PURPOSE.
# # # See the included license for more details.

#!/bin/bash

if [ -L $BASH_SOURCE ]; then
    linkpath=`readlink $BASH_SOURCE`
    AKIMA_PATH=`dirname $linkpath`
else
    AKIMA_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

if [[ "$1" == "install" ]]; then
    cd $AKIMA_PATH; python setup.py install
else
    echo "UNRECOGNIZED COMMAND $1"
    exit 1
fi

