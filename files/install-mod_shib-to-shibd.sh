#!/bin/sh

checkmodule -m -M -o mod_shib-to-shibd.mod mod_shib-to-shibd.te
semodule_package -o mod_shib-to-shibd.pp -m mod_shib-to-shibd.mod
semodule -i mod_shib-to-shibd.pp
