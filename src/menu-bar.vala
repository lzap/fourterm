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
	private ImageMenuItem item_about = new ImageMenuItem(Gtk.Stock.ABOUT);
	private ImageMenuItem item_preferences = new ImageMenuItem(Gtk.Stock.PREFERENCES);
	private ImageMenuItem item_clear = new ImageMenuItem(Gtk.Stock.CLEAR);
	private ImageMenuItem item_copy = new ImageMenuItem(Gtk.Stock.COPY);
	private ImageMenuItem item_paste = new ImageMenuItem(Gtk.Stock.PASTE);
	private ImageMenuItem item_new_window = new ImageMenuItem(Gtk.Stock.NEW, _("New Window"));
	private ImageMenuItem item_quit = new ImageMenuItem(Gtk.Stock.QUIT);
	private Gtk.AccelGroup accel_group = new Gtk.AccelGroup();

	public Menubar()
	{
		// Just an exemple:
		// this.item.accel_group = this.accel_group;

		var menu_file = new MenuItem(_("File"), {
				this.item_new_window,
				new Gtk.SeparatorMenuItem(),
				this.item_quit});

		var menu_edit = new MenuItem(_("Edit"), {
				this.item_copy,
				this.item_paste,
				new Gtk.SeparatorMenuItem(),
				this.item_preferences});

		var menu_tools = new MenuItem(_("Tools"), {
				this.item_clear});

		var menu_help = new MenuItem(_("Help"), {
				this.item_about});

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
							   Delegates.Void new_window,
							   Delegates.Void quit)
	{
		add_accel_group(this.accel_group);

		this.item_about.activate.connect(() => about());
		this.item_preferences.activate.connect(() => preferences());
		this.item_clear.activate.connect(() => clear());
		this.item_copy.activate.connect(() => copy());
		this.item_paste.activate.connect(() => paste());
		this.item_new_window.activate.connect(() => new_window());
		this.item_quit.activate.connect(() => quit());
	}
}