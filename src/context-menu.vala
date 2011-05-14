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

public class ContextMenu : Gtk.Menu
{
	private ImageMenuItem item_copy = new ImageMenuItem(Gtk.Stock.COPY);
	private ImageMenuItem item_paste = new ImageMenuItem(Gtk.Stock.PASTE);
	private ImageMenuItem item_new_window = new ImageMenuItem(Gtk.Stock.NEW, _("New Window"));

	public ContextMenu()
	{
		this.append(this.item_copy);
		this.append(this.item_paste);
		this.append(new Gtk.SeparatorMenuItem());
		this.append(this.item_new_window);
	}

	public void active_signals(Delegates.Void copy, Delegates.Void paste, Delegates.Void new_window)
	{
		this.item_copy.activate.connect(() => copy());
		this.item_paste.activate.connect(() => paste());
		this.item_new_window.activate.connect(() => new_window());
	}
}