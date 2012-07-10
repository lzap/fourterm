/****************************
** Copyright © 2011 Jacques-Pascal Deplaix, Lukas Zapletal
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

  delegate Gtk.Widget WidgetCreator();

  public MainWindow()
  {
    this.title = "FourTerm";
    this.icon = new Gdk.Pixbuf.from_xpm_data(Pictures.logo);
    this.window_count++;
    this.terminals = new Gee.ArrayList<Terminal>();
    this.scrolled_windows = new Gee.ArrayList<Gtk.ScrolledWindow>();

    int rows = Settings.rows;
    int cols = Settings.columns;
    int size = rows * cols;
    gridManager = new GridManager(rows, cols);

    for (int i = 0; i < size; i++) {
      var term = new Terminal();
      var sw = new Gtk.ScrolledWindow(null, null);
      terminals.add(term);
      scrolled_windows.add(sw);
      sw.add(term);
      sw.set_size_request(10, 10);
    }

    this.show_scrollbar(Settings.show_scrollbar);

    // create panes (minimum is 2x2)
    int scrolled_window_create = 0;
    var rows_pane = create_paned(typeof(Gtk.VPaned), rows, 
      () => {
          return create_paned(typeof(Gtk.HPaned), cols, 
            () => scrolled_windows[scrolled_window_create++]);
        });
    var main_box = new Gtk.VBox(false, 0);
    main_box.pack_start(this.menubar, false);
    main_box.pack_start(rows_pane);
    this.active_signals();
    this.add(main_box);
  }

  // TODO share this on my blog or something :-)
  private Gtk.Paned create_paned(Type pane_type, int left, WidgetCreator creator) {
    var pane = (Gtk.Paned) Object.new(pane_type);
    if (left <= 2) {
      pane.pack1(creator(), true, true);
      pane.pack2(creator(), true, true);
      return pane;
    } else {
      pane.pack1(creator(), true, true);
      pane.pack2(create_paned(pane_type, --left, creator), true, true);
      return pane;
    }
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
          return true;
        // next term (ALT+RIGHT, WIN+H, WIN+N)
        } else if ((super && event.keyval == 108) ||
          (mod1 && event.keyval == 65363) ||
          (super && event.keyval == 110)) {
          gridManager.right();
          terminals[gridManager.index].grab_focus();
          return true;
        // bellow term (ALT+DOWN, WIN+J)
        } else if ((super && event.keyval == 106) ||
          (mod1 && event.keyval == 65364)) {
          gridManager.down();
          terminals[gridManager.index].grab_focus();
          return true;
        // above term (ALT+UP, WIN+K)
        } else if ((super && event.keyval == 107) ||
          (mod1 && event.keyval == 65362)) {
          gridManager.up();
          terminals[gridManager.index].grab_focus();
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
        //TODO: t.display_menubar()
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
    bool return_value = true;

    foreach (Terminal t in terminals) {
      if(t.has_foreground_process())
      {
        var dialog = new MessageDialog(this, tr("There is still a process running in this terminal. Closing the window will kill it."), tr("Would you closing this window ?"));

        if(dialog.run() == Gtk.ResponseType.OK)
        {
          return_value = false;
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
