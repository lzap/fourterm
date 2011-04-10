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

public class ConfigurationsWindow : Gtk.Dialog
{
	private ConfigurationsWindow(MainWindow parent_window)
	{
		this.transient_for = parent_window;

		this.add_buttons(Gtk.Stock.OK, Gtk.ResponseType.OK,
						 Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL);
	}

	public static void display(MainWindow parent_window)
	{
		var window = new ConfigurationsWindow(parent_window);
		window.run();
		window.destroy();
	}
}