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

	public Terminal()
	{
        this.background_transparent = false;
        this.scroll_on_keystroke = true;

		// FIXME: fork_command is deprecated. Use fork_command_full instead.
		this.fork_command(null, null, null, GLib.Environment.get_home_dir(), true, true, true);
        //this.fork_command_full(Vte.PtyFlags.DEFAULT, null, {}, null, GLib.SpawnFlags.FILE_AND_ARGV_ZERO, this.gne, cpid);
		//bool Vte.Terminal.fork_command_full (Vte.PtyFlags pty_flags, string? working_directory, string[]? argv, string[]? envv, GLib.SpawnFlags spawn_flags, GLib.SpawnChildSetupFunc child_setup, GLib.Pid child_pid)
	}

	public void active_signals(Delegates.String title_changed)
	{
		this.button_press_event.connect(this.display_menu);
		this.window_title_changed.connect(() => title_changed(this.window_title));

		this.context_menu.active_signals(() => this.copy_clipboard(),
										 () => this.paste_clipboard());
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
}