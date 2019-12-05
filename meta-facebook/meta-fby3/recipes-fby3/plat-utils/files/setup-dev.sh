#! /bin/sh
#
# Copyright 2015-present Facebook. All Rights Reserved.
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA
#
. /usr/local/fbpackages/utils/ast-functions

function create_new_dev() {
  local dev_name=$1
  local addr=$2
  local bus=$3

  echo $dev_name $addr > /sys/class/i2c-dev/i2c-${bus}/device/new_device
}

function init_class1_dev(){
  #enable the register of the temperature
  /usr/sbin/i2cset -y 11 0x40 0xd4 0x1c 0x3f i
  create_new_dev "lm75" 0x4e 12
  create_new_dev "lm75" 0x4f 12
}

function init_class2_dev(){
  create_new_dev "lm75" 0x4f 2
}

create_new_dev "tmp421" 0x1f 8

bmc_location=$(get_bmc_board_id)
if [ $bmc_location -eq 9 ]; then
  #The BMC of class2
  init_class2_dev
elif [ $bmc_location -eq 14 ]; then
  #The BMC of class1
  init_class1_dev
else
  echo -n "Is board id correct(id=$bmc_location)?..."
fi

echo "Done."
