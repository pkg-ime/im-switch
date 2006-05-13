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

# $tmplang is locale <languag>e_<region> without .<encoding> and .<encoding>@EURO
tmplang=${LC_ALL:-${LC_CTYPE:-${LANG}}}
tmplang=${tmplang%@*}
tmplang=${tmplang%.*}

## try to source ~/.xinput.d/ll_CC or /etc/X11/xinit/xinput.d/ll_CC to
## setup the input method for locale (CC is needed for Chinese for example)
# unset env vars to be safe
_XIM=$XIM
_XIM_PROGRAM=$XIM_PROGRAM
_XIM_ARGS=$XIM_ARGS
_XMODIFIERS=$XMODIFIERS
_GTK_IM_MODULE=$GTK_IM_MODULE
_QT_IM_MODULE=$QT_IM_MODULE

lang_region="$tmplang"
for f in $HOME/.xinput.d/${lang_region} \
	    /etc/X11/xinit/xinput.d/${lang_region} \
	    $HOME/.xinput.d/default \
	    /etc/X11/xinit/xinput.d/default ; do
    [ -r $f ] && . $f && break
done
unset lang_region

[ "$_XIM" ] && XIM=$_XIM
[ "$_XIM_PROGRAM" ] && XIM_PROGRAM=$_XIM_PROGRAM
[ "$_XIM_ARGS" ] && XIM_ARGS=$_XIM_ARGS
[ "$_XMODIFIERS" ] && XMODIFIERS=$_XMODIFIERS
[ "$_GTK_IM_MODULE" ] && GTK_IM_MODULE=$_GTK_IM_MODULE
[ "$_QT_IM_MODULE" ] && QT_IM_MODULE=$_QT_IM_MODULE

[ -n "$GTK_IM_MODULE" ] && export GTK_IM_MODULE
[ -n "$QT_IM_MODULE" ] && export QT_IM_MODULE

# setup XMODIFIERS
[ -z "$XMODIFIERS" -a -n "$XIM" ] && XMODIFIERS="@im=$XIM"
[ -n "$XMODIFIERS" ] && export XMODIFIERS

# execute XIM_PROGRAM
[ -n "$XIM_PROGRAM" -a -x "$XIM_PROGRAM" ] && "$XIM_PROGRAM" $XIM_ARGS &
