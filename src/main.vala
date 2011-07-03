/****************************
** Copyright © 2011 Jacques-Pascal Deplaix
**
** ValaTerm is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
****************************/

void main(string[] args)
{
	Gtk.init(ref args);

#if ENABLE_NLS
	GLib.Intl.setlocale(GLib.LocaleCategory.ALL, "");
	GLib.Intl.bindtextdomain(Config.GETTEXT_PACKAGE, Config.LOCALE_DIR);
	GLib.Intl.textdomain(Config.GETTEXT_PACKAGE);
#endif

	var window = new MainWindow();
	window.display();

	Gtk.main();
}

public unowned string tr(string str)
{
#if ENABLE_NLS
	return GLib._(str);
#else
	return str;
#endif
}