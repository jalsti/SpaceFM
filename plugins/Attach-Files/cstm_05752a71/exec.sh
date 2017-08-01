#!/bin/bash
$fm_import    # import file manager variables (scroll down for info)
#
# Enter your commands here:     ( then save this file )

# NAME: _Attach Files
# ICON: applications-mail

<<DESCRIPTION
    Attach is a plugin for the SpaceFM file manager. This plugin opens a compose 
    window of your favourite e-mail application with the selected files attached.
DESCRIPTION

<<COPYRIGHT
    Copyright (C) 2012-2013  Serge YMR Stroobandt

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
COPYRIGHT

<<CONTACT
    serge@stroobandt.com
CONTACT

<<VERSION
    1.1
VERSION

FILES=$(for FILE in "${fm_files[@]}"; do
echo "file://"$(readlink -f "$FILE")""
done | xargs | sed "s/ file:\/\//,file:\/\//g")
[ -x /usr/bin/icedove ] && exec icedove -compose "attachment='$FILES'" || [ -x /usr/bin/thunderbird ] && exec thunderbird -compose "attachment='$FILES'" || [ -x /usr/bin/claws-mail ] && exec claws-mail --compose --attach "$@" || exec xdg-email --attach "$1"

exit $?
