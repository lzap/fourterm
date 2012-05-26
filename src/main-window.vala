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
  private GridManager gridManager;
  private Gee.ArrayList<Terminal> terminals;
	private Gee.ArrayList<Gtk.ScrolledWindow> scrolled_windows;

	public MainWindow()
	{
		this.title = "FourTerm";
		this.icon = new Gdk.Pixbuf.from_xpm_data(Pictures.logo);
		this.window_count++;
    this.terminals = new Gee.ArrayList<Terminal>();
	  this.scrolled_windows = new Gee.ArrayList<Gtk.ScrolledWindow>();

    int size;
    if (Settings.four_terms) {
      size = 4;
      gridManager = new GridManager(2, 2);
    } else {
      size = 1;
      // TODO test this!
      gridManager = new GridManager(1, 1);
    }

    for (int i = 0; i < size; i++) {
      var term = new Terminal();
	    var sw = new Gtk.ScrolledWindow(null, null);
      terminals.add(term);
      scrolled_windows.add(sw);
	    sw.add(term);
      sw.set_size_request(-1, 300);
    }

		this.show_scrollbar(Settings.show_scrollbar);

    var top_pane = new Gtk.HPaned();
		top_pane.pack1(scrolled_windows[0], true, true);
		top_pane.pack2(scrolled_windows[1], true, true);
    var bottom_pane = new Gtk.HPaned();
		bottom_pane.pack1(scrolled_windows[2], true, true);
		bottom_pane.pack2(scrolled_windows[3], true, true);
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

		this.resize(this.terminals[gridManager.index].calcul_width(80) * 2,
					this.terminals[gridManager.index].calcul_height(24) * 2);

		// Do that after resize because Vte add rows if the main window is too small...
    foreach (Terminal t in terminals) {
		  t.active_shell(shell_cwd);
    }
	}

	private void active_signals()
	{
		this.menubar.about.connect(() => About.display(this));
		this.menubar.preferences.connect(() =>
		{
			var dialog = new ParametersWindow(this);
      foreach (Terminal t in terminals) {
        dialog.font_changed.connect(t.set_font_from_string);
        dialog.scrollback_lines_changed.connect(t.set_scrollback_lines);
        dialog.transparency_changed.connect(t.set_background_transparent);
      }
			dialog.show_scrollbar_changed.connect(this.show_scrollbar);
			dialog.show_all();
		});
		this.menubar.clear.connect(() => this.terminals[gridManager.index].reset(true, true));
		this.menubar.copy.connect(() => this.terminals[gridManager.index].copy_clipboard());
		this.menubar.paste.connect(() => this.terminals[gridManager.index].paste_clipboard());
		this.menubar.select_all.connect(() => this.terminals[gridManager.index].select_all());
		this.menubar.new_window.connect(this.new_window);
		this.menubar.quit.connect(this.exit);

		this.delete_event.connect(this.on_delete);
		this.destroy.connect(this.on_destroy);
    
    foreach (Terminal t in terminals) {
      t.child_exited.connect(() => t.active_shell(GLib.Environment.get_home_dir()));

      t.key_press_event.connect((source, event) => {
        if (event.type == Gdk.EventType.KEY_RELEASE) return false;
        bool super = (event.state & Gdk.ModifierType.SUPER_MASK) != 0; // windows mod
        bool mod1 = (event.state & Gdk.ModifierType.MOD1_MASK) != 0; // alt mod
        // previous term (ALT+LEFT, WIN+H, WIN+P)
        if ((super && event.keyval == 104) || 
          (mod1 && event.keyval == 65361) ||
          (super && event.keyval == 112)) {
          gridManager.left();
          terminals[gridManager.index].grab_focus();
          //GLib.stdout.printf("%p %p %p %p", terminals[0], terminals[1], terminals[2], terminals[3]);
          //GLib.stdout.printf("active: %d, size: %d\n", gridManager.index, terminals.size);
          return true;
        // next term (ALT+RIGHT, WIN+H, WIN+N)
        } else if ((super && event.keyval == 108) ||
          (mod1 && event.keyval == 65363) ||
          (super && event.keyval == 110)) {
          gridManager.right();
          terminals[gridManager.index].grab_focus();
          //GLib.stdout.printf("%p %p %p %p", terminals[0], terminals[1], terminals[2], terminals[3]);
          //GLib.stdout.printf("active: %d, size: %d\n", gridManager.index, terminals.size);
          return true;
        // bellow term (ALT+DOWN, WIN+J)
        } else if ((super && event.keyval == 106) ||
          (mod1 && event.keyval == 65364)) {
          gridManager.down();
          terminals[gridManager.index].grab_focus();
          //GLib.stdout.printf("%p %p %p %p", terminals[0], terminals[1], terminals[2], terminals[3]);
          //GLib.stdout.printf("active: %d, size: %d\n", gridManager.index, terminals.size);
          return true;
        // above term (ALT+UP, WIN+K)
        } else if ((super && event.keyval == 107) ||
          (mod1 && event.keyval == 65362)) {
          gridManager.up();
          terminals[gridManager.index].grab_focus();
          //GLib.stdout.printf("%p %p %p %p", terminals[0], terminals[1], terminals[2], terminals[3]);
          //GLib.stdout.printf("active: %d, size: %d\n", gridManager.index, terminals.size);
          return true;
        } else if (super && event.keyval == 99) {
            if (Settings.daylight_palette)
              Settings.daylight_palette = false;
            else
              Settings.daylight_palette = true;
            foreach (Terminal tc in terminals)
              tc.setup_colors();
          return true;
        }
        //GLib.stdout.printf("key: %s %u\n", event.str, event.keyval);
        //GLib.stdout.printf("active: %d, size: %d\n", gridManager.index, terminals.size);
        return false;
      });

		  t.title_changed.connect((term, title) => {
        if (term == this.terminals[gridManager.index] && title != null)
          this.set_title(title);
      });

      t.focus_in_event.connect((event) =>
      {
        gridManager.index = terminals.index_of(t);
        if (this.terminals[gridManager.index].window_title != null)
          this.set_title(this.terminals[gridManager.index].window_title);
        return false;
      });
    }

		//this.terminals[gridManager.index].title_changed.connect(this.set_title);
		this.terminals[gridManager.index].new_window.connect(this.new_window);
		this.terminals[gridManager.index].display_menubar.connect(this.menubar.set_visible);
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

    foreach (Terminal t in terminals) {
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
		window.display(this.terminals[gridManager.index].get_shell_cwd());
	}

	private void show_scrollbar(bool show)
	{
    foreach (Gtk.ScrolledWindow sw in scrolled_windows) {
      if(show == true)
        sw.set_policy(Gtk.PolicyType.AUTOMATIC, Gtk.PolicyType.AUTOMATIC);
      else
        sw.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.NEVER);
    }
	}
}
