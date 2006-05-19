#!/bin/sh
# Copyright (C) 2005 Kenshi Muto <kmuto@debian.org> 
#  Modified for Debian package.
# Copyright (C) 1999 - 2004 Red Hat, Inc. All rights reserved. This
# copyrighted material is made available to anyone wishing to use, modify,
# copy, or redistribute it subject to the terms and conditions of the
# GNU General Public License version 2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# X Input method setup script


# Check other configuration has not configured IM
if [ -z "$XIM" -a -z "$XIM_PROGRAM" -a -z "$XIM_ARGS" -a -z "$XMODIFIERS" \
     -a -z "$GTK_IM_MODULE" -a -z "$QT_IM_MODULE" ]; then

# $LNG is locale <language>_<region> without .<encoding> and .<encoding>@EURO
LNG=${LC_ALL:-${LC_CTYPE:-${LANG}}}
LNG=${LNG%@*}
LNG=${LNG%.*}

[ -z "$LNG" ] && LNG="en_US"

# Source first found configuration under $LNG locale
for f in    "$HOME/.xinput.d/${LNG}" \
	    "$HOME/.xinput.d/all_ALL" \
	    "/etc/X11/xinit/xinput.d/${LNG}" \
	    "/etc/X11/xinit/xinput.d/all_ALL" \
	    "/etc/X11/xinit/xinput.d/default" ; do
    [ -f "$f" -a -r "$f" ] && . "$f" && break
done

unset LNG

[ -n "$GTK_IM_MODULE" ] && export GTK_IM_MODULE
[ -n "$QT_IM_MODULE" ] && export QT_IM_MODULE

# setup XMODIFIERS
[ -z "$XMODIFIERS" -a -n "$XIM" ] && XMODIFIERS="@im=$XIM"
[ -n "$XMODIFIERS" ] && export XMODIFIERS

# execute XIM_PROGRAM
[ -n "$XIM_PROGRAM" -a -x "$XIM_PROGRAM" ] && eval "$XIM_PROGRAM $XIM_ARGS &"

# execute XIM_PROGRAM_XTRA
[ -n "$XIM_PROGRAM_XTRA" ] && eval "$XIM_PROGRAM_EXTRA &"

fi
