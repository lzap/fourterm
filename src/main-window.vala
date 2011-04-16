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

public class MainWindow : Gtk.Window
{
	private Menubar menubar = new Menubar();
	private Terminal terminal = new Terminal();

	public MainWindow()
	{
		this.title = "ValaTerm";
		this.icon = new Gdk.Pixbuf.from_xpm_data(Pictures.logo);

		var scrolled_window = new Gtk.ScrolledWindow(null, null);
		scrolled_window.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
		scrolled_window.add(this.terminal);

		var main_box = new Gtk.VBox(false, 1);
		main_box.pack_start(this.menubar, false);
		main_box.pack_start(scrolled_window);

		this.active_signals();
		this.add(main_box);
	}

	public void display()
	{
		this.show_all();
		this.resize(this.terminal.calcul_width(80), this.terminal.calcul_height(24));
	}

	private void active_signals()
	{
		// Just for set it more shorter
		Delegates.Void configurations_window = () =>
		{
			ConfigurationsWindow.display(this,
										 (font) => this.terminal.set_font_from_string(font),
										 (color) => this.terminal.set_color_background(color),
										 (color) => this.terminal.set_color_foreground(color));
		};

		this.menubar.active_signals(this.add_accel_group,
									() => About.display(this),
									configurations_window,
									() => this.terminal.reset(true, true),
									() => this.terminal.copy_clipboard(),
									() => this.terminal.paste_clipboard());

		this.destroy.connect(Gtk.main_quit);
		this.terminal.child_exited.connect(Gtk.main_quit);

		this.terminal.active_signals((title) => this.title = title);
	}
}