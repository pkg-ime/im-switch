#!/usr/bin/perl -w
#  Dependency check.
#   Copyright (c) 2005 Kenshi Muto <kmuto@debian.org> All rights reserved.
# This copyrighted material is made available to anyone wishing to use, modify,
# copy, or redistribute it subject to the terms and conditions of the
# GNU General Public License version 2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

exit(0) if (@ARGV < 1);
use AptPkg::Cache;
my($cache) = AptPkg::Cache->new;

sub isInstalled {
  my($package) = @_;
  my($p) = $cache->{$package};
  if ($p) {
    return 1 if ($p->{CurrentVer});
  }
  return 0;
}

sub parse {
  my($packages) = @_;
  my($missing) = "";
  my($flag) = 0;
  $packages =~ s/[[:space:]]+//g;
  my(@pa) = split(/,/, $packages);
  foreach (@pa) {
    my(@pas) = split(/\|/, $_);
    $flag = 0;
    foreach (@pas) {
      if (isInstalled($_)) {
        $flag = 1;
        last;
      }
    }
    $missing .= $_ . ", " unless ($flag);
  }
  chop($missing); chop($missing);
  return $missing;
}

print &parse($ARGV[0]);
