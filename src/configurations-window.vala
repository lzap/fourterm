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
	private Gtk.FontButton font_chooser = new Gtk.FontButton();

	private Delegates.String font_changed;

	private ConfigurationsWindow(MainWindow parent_window)
	{
		this.title = _("ValaTerm Preferences");
		this.transient_for = parent_window;

		var font_box = new Gtk.HBox(false, 1);
		font_box.pack_start(new Gtk.Label(_("Police:")));
		font_box.pack_start(this.font_chooser);

		this.vbox.pack_start(font_box);

		this.add_buttons(Gtk.Stock.OK, Gtk.ResponseType.OK,
						 Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL);
	}

	private void active_signals(Delegates.String font_changed)
	{
		this.font_changed = font_changed;
	}

	public static void display(MainWindow parent_window,
							   Delegates.String font_changed)
	{
		var window = new ConfigurationsWindow(parent_window);
		window.active_signals(font_changed);
		window.show_all();
	}

	protected override void response(int response_id)
	{
		if(response_id == Gtk.ResponseType.OK)
		{
			this.ok_clicked();
		}

		this.destroy();
	}

	private void ok_clicked()
	{
		Settings.terminal_font = this.font_chooser.font_name;
		this.font_changed(Settings.terminal_font);
	}
}