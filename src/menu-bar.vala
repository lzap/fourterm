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
	private Gtk.ImageMenuItem item_about = new Gtk.ImageMenuItem.from_stock(Gtk.Stock.ABOUT, null);
	private Gtk.ImageMenuItem item_preferences = new Gtk.ImageMenuItem.from_stock(Gtk.Stock.PREFERENCES, null);
	private Gtk.ImageMenuItem item_clear = new Gtk.ImageMenuItem.from_stock(Gtk.Stock.CLEAR, null);
	private Gtk.ImageMenuItem item_copy = new Gtk.ImageMenuItem.from_stock(Gtk.Stock.COPY, null);
	private Gtk.ImageMenuItem item_paste = new Gtk.ImageMenuItem.from_stock(Gtk.Stock.PASTE, null);
	private Gtk.ImageMenuItem item_new_window = new Gtk.ImageMenuItem.from_stock(Gtk.Stock.NEW, null);
	private Gtk.AccelGroup accel_group = new Gtk.AccelGroup();

	public Menubar()
	{
		this.item_clear.label = _("Clear");
		this.item_preferences.label = _("Preferences");
		this.item_about.label = _("About");
		this.item_copy.label = _("Copy");
		this.item_paste.label = _("Paste");
		this.item_new_window.label = _("New Window");

		// Just an exemple:
		// this.item.accel_group = this.accel_group;

		var menu_file = new Gtk.MenuItem.with_label(_("File"));
		var submenu_file = new Gtk.Menu();
		menu_file.set_submenu(submenu_file);
		submenu_file.append(this.item_new_window);

		var menu_edit = new Gtk.MenuItem.with_label(_("Edit"));
		var submenu_edit = new Gtk.Menu();
		menu_edit.set_submenu(submenu_edit);
		submenu_edit.append(this.item_copy);
		submenu_edit.append(this.item_paste);
		submenu_edit.append(new Gtk.SeparatorMenuItem());
		submenu_edit.append(this.item_preferences);

		var menu_tools = new Gtk.MenuItem.with_label(_("Tools"));
		var submenu_tools = new Gtk.Menu();
		menu_tools.set_submenu(submenu_tools);
		submenu_tools.append(this.item_clear);

		var menu_help = new Gtk.MenuItem.with_label(_("Help"));
		var submenu_help = new Gtk.Menu();
		menu_help.set_submenu(submenu_help);
		submenu_help.append(this.item_about);

		this.append(menu_file);
		this.append(menu_edit);
		this.append(menu_tools);
		this.append(menu_help);
	}

	public void active_signals(Delegates.AccelGroup add_accel_group,
							   Delegates.Void about,
							   Delegates.Void preferences,
							   Delegates.Void clear,
							   Delegates.Void copy,
							   Delegates.Void paste,
							   Delegates.Void new_window)
	{
		add_accel_group(this.accel_group);

		this.item_about.activate.connect(() => about());
		this.item_preferences.activate.connect(() => preferences());
		this.item_clear.activate.connect(() => clear());
		this.item_copy.activate.connect(() => copy());
		this.item_paste.activate.connect(() => paste());
		this.item_new_window.activate.connect(() => new_window());
	}
}