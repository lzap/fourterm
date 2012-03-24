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
	private Terminal[] terminal;
	private Terminal active_terminal;
	private Gtk.ScrolledWindow[] scrolled_window;

	public MainWindow()
	{
		this.title = "FourTerm";
		this.icon = new Gdk.Pixbuf.from_xpm_data(Pictures.logo);
		this.show_scrollbar(Settings.show_scrollbar);
		this.window_count++;

    if (Settings.four_terms) {
      terminal = new Terminal[4];
      scrolled_window = new Gtk.ScrolledWindow[4];
    } else {
      terminal = new Terminal[1];
      scrolled_window = new Gtk.ScrolledWindow[1];
    }

    for (int i = 0; i < terminal.length; i++) {
      terminal[i] = new Terminal();
	    scrolled_window[i] = new Gtk.ScrolledWindow(null, null);
	    scrolled_window[i].add(this.terminal[i]);
    }
    active_terminal = terminal[0];

    var top_pane = new Gtk.HPaned();
		top_pane.pack1(scrolled_window[0], true, true);
		top_pane.pack2(scrolled_window[1], true, true);
    var bottom_pane = new Gtk.HPaned();
		bottom_pane.pack1(scrolled_window[2], true, true);
		bottom_pane.pack2(scrolled_window[3], true, true);
    var main_pane = new Gtk.VPaned();
		main_pane.pack1(top_pane, true, true);
		main_pane.pack2(bottom_pane, true, true);

		var main_box = new Gtk.VBox(false, 0);
		main_box.pack_start(this.menubar, false);
		main_box.pack_start(main_pane);

		this.active_signals();
		this.add(main_box);
	}

	public void display(string shell_cwd = GLib.Environment.get_home_dir())
	{
		this.show_all();

		this.resize(this.active_terminal.calcul_width(80) * 2,
					this.active_terminal.calcul_height(24) * 2);

		// Do that after resize because Vte add rows if the main window is too small...
    foreach (Terminal t in terminal) {
		  t.active_shell(shell_cwd);
    }
	}

	private void active_signals()
	{
		this.menubar.about.connect(() => About.display(this));
		this.menubar.preferences.connect(() =>
		{
			var dialog = new ParametersWindow(this);
      foreach (Terminal t in terminal) {
        dialog.font_changed.connect(t.set_font_from_string);
        dialog.background_color_changed.connect(t.set_color_background);
        dialog.foreground_color_changed.connect(t.set_color_foreground);
        dialog.scrollback_lines_changed.connect(t.set_scrollback_lines);
        dialog.transparency_changed.connect(t.set_background_transparent);
      }
			dialog.show_scrollbar_changed.connect(this.show_scrollbar);
			dialog.show_all();
		});
		this.menubar.clear.connect(() => this.active_terminal.reset(true, true));
		this.menubar.copy.connect(() => this.active_terminal.copy_clipboard());
		this.menubar.paste.connect(() => this.active_terminal.paste_clipboard());
		this.menubar.select_all.connect(() => this.active_terminal.select_all());
		this.menubar.new_window.connect(this.new_window);
		this.menubar.quit.connect(this.exit);

		this.delete_event.connect(this.on_delete);
		this.destroy.connect(this.on_destroy);
    
    // Cannot do this in a loop due to closure bug in Vala
    // TODO: use gee array
    // BZ https://bugzilla.gnome.org/show_bug.cgi?id=672767
    terminal[0].child_exited.connect(() => terminal[0].active_shell(GLib.Environment.get_home_dir()));
    terminal[1].child_exited.connect(() => terminal[1].active_shell(GLib.Environment.get_home_dir()));
    terminal[2].child_exited.connect(() => terminal[2].active_shell(GLib.Environment.get_home_dir()));
    terminal[3].child_exited.connect(() => terminal[3].active_shell(GLib.Environment.get_home_dir()));

		//this.active_terminal.title_changed.connect(this.set_title);
		this.active_terminal.new_window.connect(this.new_window);
		this.active_terminal.display_menubar.connect(this.menubar.set_visible);

    for (int i = 0; i < terminal.length; i++) {
		  this.terminal[i].title_changed.connect((term, title) => {
        if (term == this.active_terminal)
          this.set_title(title);
      });
    }

    // BZ https://bugzilla.gnome.org/show_bug.cgi?id=672767
    terminal[0].focus_in_event.connect((event) =>
    {
      this.active_terminal = terminal[0];
      this.set_title(this.active_terminal.window_title);
      return false;
    });
    terminal[1].focus_in_event.connect((event) =>
    {
      this.active_terminal = terminal[1];
      this.set_title(this.active_terminal.window_title);
      return false;
    });
    terminal[2].focus_in_event.connect((event) =>
    {
      this.active_terminal = terminal[2];
      this.set_title(this.active_terminal.window_title);
      return false;
    });
    terminal[3].focus_in_event.connect((event) =>
    {
      this.active_terminal = terminal[3];
      this.set_title(this.active_terminal.window_title);
      return false;
    });
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

    foreach (Terminal t in terminal) {
      if(t.has_foreground_process())
      {
        var dialog = new MessageDialog(this, tr("There is still a process running in this terminal. Closing the window will kill it."), tr("Would you closing this window ?"));

        if(dialog.run() == Gtk.ResponseType.CANCEL)
        {
          return_value = true;
        }

        dialog.destroy();
        break;
      }
    }

		return return_value;
	}

	private void new_window()
	{
		var window = new MainWindow();
		window.display(this.active_terminal.get_shell_cwd());
	}

	private void show_scrollbar(bool show)
	{
    for (int i = 0; i < terminal.length; i++) {
      if(show == true)
        this.scrolled_window[i].set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
      else
        this.scrolled_window[i].set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.NEVER);
    }
	}
}
