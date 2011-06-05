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

public class Terminal : Vte.Terminal
{
	private ContextMenu context_menu = new ContextMenu();
	private GLib.Pid? child_pid = null;

#if VTE_SUP_0_26 && VALAC_SUP_0_12_1
	private string shell = Terminal.get_shell();
#endif

	public signal void title_changed(string title);
	public signal void new_window();
	public signal void display_menubar(bool show);

	public Terminal()
	{
        this.scroll_on_keystroke = true;

        this.background_transparent = Settings.transparency;
		this.scrollback_lines = Settings.scrollback_lines;
		this.set_font_from_string(Settings.font);
		this.set_colors(Settings.foreground_color,
						Settings.background_color,
						Colors.colors_palette);

		this.active_signals();
	}

	private void active_signals()
	{
		this.button_press_event.connect(this.display_menu);
		this.window_title_changed.connect(() => this.title_changed(this.window_title));

		this.context_menu.copy.connect(() => this.copy_clipboard());
		this.context_menu.paste.connect(() => this.paste_clipboard());
		this.context_menu.new_window.connect(() => this.new_window());
		this.context_menu.display_menubar.connect((a) => this.display_menubar(a));
	}

	public void active_shell()
	{
// This part can only be compiled by valac >= 0.12.1 (see commit: c677)
#if VTE_SUP_0_26 && VALAC_SUP_0_12_1
		try
		{
			string[] args = {};

			GLib.Shell.parse_argv(this.shell, out args);
			this.fork_command_full(Vte.PtyFlags.DEFAULT, GLib.Environment.get_home_dir(), args, null, GLib.SpawnFlags.SEARCH_PATH, null, out this.child_pid);
		}
		catch(GLib.Error error)
		{
			// Do something !
		}
#else
		this.child_pid = this.fork_command(null, null, null, GLib.Environment.get_home_dir(), true, true, true);
#endif
	}

	public int calcul_width(int column_count)
	{
		return (this.allocation.width * column_count) / (int)(this.get_column_count());
	}

	public int calcul_height(int row_count)
	{
		return (this.allocation.height * row_count) / (int)(this.get_row_count());
	}

	private bool display_menu(Gdk.EventButton event)
	{
		if(event.button == 3) // 3 is the right button
		{
			this.context_menu.show_all();
			context_menu.popup(null, null, null, event.button, event.time);

			return true;
		}

		return false;
	}

	public bool has_foreground_process()
	{
		int fgpid = Posix.tcgetpgrp(this.pty);
		return fgpid != this.child_pid && fgpid != -1;
	}

#if VTE_SUP_0_26 && VALAC_SUP_0_12_1
	private static string get_shell()
	{
		string? shell = GLib.Environment.get_variable("SHELL");

		if(shell == null)
		{
			shell = "/bin/sh";
		}

		return shell;
	}
#endif
}