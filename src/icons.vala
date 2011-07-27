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

namespace Icons
{
#if VALA_0_12
	const string ABOUT = Gtk.Stock.ABOUT;
	const string PREFERENCES = Gtk.Stock.PREFERENCES;
	const string CLEAR = Gtk.Stock.CLEAR;
	const string COPY = Gtk.Stock.COPY;
	const string PASTE = Gtk.Stock.PASTE;
	const string NEW = Gtk.Stock.NEW;
	const string QUIT = Gtk.Stock.QUIT;
	const string OK = Gtk.Stock.OK;
	const string CANCEL = Gtk.Stock.CANCEL;
	const string SELECT_ALL = Gtk.Stock.SELECT_ALL;
#else
	const string ABOUT = Gtk.STOCK_ABOUT;
	const string PREFERENCES = Gtk.STOCK_PREFERENCES;
	const string CLEAR = Gtk.STOCK_CLEAR;
	const string COPY = Gtk.STOCK_COPY;
	const string PASTE = Gtk.STOCK_PASTE;
	const string NEW = Gtk.STOCK_NEW;
	const string QUIT = Gtk.STOCK_QUIT;
	const string OK = Gtk.STOCK_OK;
	const string CANCEL = Gtk.STOCK_CANCEL;
	const string SELECT_ALL = Gtk.STOCK_SELECT_ALL;
#endif
}