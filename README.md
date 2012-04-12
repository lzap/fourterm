
Lightweight split-screen terminal emulator with vim keys
========================================================

*FourTerm* is ultra-lightweight terminal emulator with vim-like keyboard shortcuts
for window navigation, active web and file links, search feature and sexy color
"Solarized" scheme with day/night fast switching. It is based on ValaTerm and
comparable to Terminator.

![fouterm](/lzap/fourterm/raw/master/doc/fourterm-screen1.png "FourTerm")

Features
--------

 * Very small (only one 200 kB binary - including awesome icon).
 * Faster than Terminator (written in Vala/C).
 * Starts ultra-fast. Exits even faster!
 * Built-in [Solarized color scheme](http://ethanschoonover.com/solarized).
 * Vim-like key mapping. Try Super/Windows key + hjkl or np.
 * Active terminal is highlighted.
 * Allows to choose your font and colors.

Planned features
----------------

 * Fedora 17 package.
 * Support for one, four and six terminals.
 * Dark/light color scheme switch using Super/Win + c combination.
 * Active http links and files. Open files from stacktraces in your editor quickly!
 * Effective searching in the history. No more scrolling.

Download
--------

We will provide RPMs for Fedora very soon. See bellow on how to compile.

Run Requirements
----------------

 * glib-2.0 >= 2.6
 * gtk+-2.0 >= 2.16
 * vte >= 0.20

Build Requirements
------------------

 * valac >= 0.10.0 but >= 0.12.1 is better if you using vte >= 0.26
 * gcc or Clang/LLVM
 * intltool
 * gettext
 * pkg-config

How To Compile
--------------

Tutorial for Fedora:

    # yum -y install git waf vala glib2-devel gtk3-devel vte3-devel
    # git clone git://github.com/lzap/fourterm.git
    # cd fouterm
    # waf configure --with-gtk3
    # waf
    # build/fourterm

The same for other distributions. If you don't have waf package, you can use
./waf script instead of system-wide installation.

Authors
-------

FourTerm was initially forked from [ValaTerm](https://gitorious.org/valaterm),
work of Jacques-Pascal Deplaix. Thanks!

 * Jacques-Pascal Deplaix
 * Lukas Zapletal
 * We want you!

License
-------

Copyright © 2011 Jacques-Pascal Deplaix, © 2012 Lukas Zapletal

FourTerm is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

<!-- vim:se syn=markdown:sw=4:ts=4:et: -->
