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
	private static uint window_count = 0;

	private Menubar menubar = new Menubar();
	private Terminal terminal = new Terminal();

	public MainWindow()
	{
		// FIXME: The window title keep this title instead of the shell title.
		this.title = "ValaTerm";
		this.icon = new Gdk.Pixbuf.from_xpm_data(Pictures.logo);

		this.window_count++;

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

		// Do that after resize because Vte add rows if the main window is too small...
		this.terminal.active_shell();
	}

	private void active_signals()
	{
		this.menubar.active_signals(this.add_accel_group,
									() => About.display(this),
									() => ConfigurationsWindow.display(
										this,
										this.terminal.set_font_from_string,
										this.terminal.set_color_background,
										this.terminal.set_color_foreground,
										this.terminal.set_scrollback_lines),
									() => this.terminal.reset(true, true),
									() => this.terminal.copy_clipboard(),
									() => this.terminal.paste_clipboard(),
									this.new_window,
									this.exit);

		this.delete_event.connect(this.on_delete);
		this.destroy.connect(this.on_destroy);
		this.terminal.child_exited.connect(this.exit);

		this.terminal.active_signals((title) => this.title = title,
									 this.new_window);
	}

	private void on_destroy()
	{
		if(this.window_count < 2)
		{
			Gtk.main_quit();
		}
		else
		{
			this.window_count--;
		}
	}

	private void exit()
	{
		if(this.on_delete() == false)
		{
			this.destroy();
		}
	}

	private bool on_delete()
	{
		bool return_value = false;

		if(this.terminal.has_foreground_process())
		{
			var dialog = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL, "There is still a process running in this terminal. Closing the window will kill it.");

			if(dialog.run() == Gtk.ResponseType.CANCEL)
			{
				return_value = true;
			}

			dialog.destroy();
		}

		return return_value;
	}

	private void new_window()
	{
		var window = new MainWindow();
		window.display();
	}
}