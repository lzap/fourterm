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

public class Menubar : Gtk.MenuBar
{
	private Gtk.MenuItem item_about = new Gtk.MenuItem.with_label("About");

	public Menubar()
	{
		var menu_file = new Gtk.MenuItem.with_label("Help");
		var menu = new Gtk.Menu();

		// Just an exemple:
		// menuitem.set_related_action(new Gtk.Action("f", "fg", null, null));

		menu_file.set_submenu(menu);
		menu.append(this.item_about);

		this.append(menu_file);
	}

	public void active_signals(Delegates.Void about)
	{
		this.item_about.activate.connect(() => about());
	}
}