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

public class ParametersWindow : DefaultDialog
{
	private FontButton font_chooser = new FontButton(Settings.font);
	private SpinButton scrollback_lines_chooser = new SpinButton(Settings.scrollback_lines);
	private CheckButton transparency_chooser = new CheckButton(Settings.transparency);
	private CheckButton show_scrollbar_chooser = new CheckButton(Settings.show_scrollbar);
	private SpinButton rows_chooser = new SpinButton(Settings.rows);
	private SpinButton columns_chooser = new SpinButton(Settings.columns);

	public signal void font_changed(string font);
	public signal void scrollback_lines_changed(long lines);
	public signal void transparency_changed(bool tranparency);
	public signal void show_scrollbar_changed(bool show);
	public signal void rows_changed(int lines);
	public signal void columns_changed(int lines);

	public ParametersWindow(MainWindow parent_window)
	{
		this.title = tr("ValaTerm Preferences");
		this.transient_for = parent_window;

		var rows_box = new ParameterBox(tr("Rows:"),
													this.rows_chooser);

		var columns_box = new ParameterBox(tr("Columns:"),
													this.columns_chooser);

		var font_box = new ParameterBox(tr("Font:"), this.font_chooser);

		var scrollback_lines_box = new ParameterBox(tr("Scrollback lines:"),
													this.scrollback_lines_chooser);

		var transparency_box = new ParameterBox(tr("Transparency:"),
												this.transparency_chooser);

		var show_scrollbar_box = new ParameterBox(tr("Show scrollbar:"),
												  this.show_scrollbar_chooser);

		var main_box = (Gtk.Box)(this.get_content_area());
		main_box.pack_start(rows_box);
		main_box.pack_start(columns_box);
		main_box.pack_start(font_box);
		main_box.pack_start(scrollback_lines_box);
		main_box.pack_start(transparency_box);
		main_box.pack_start(show_scrollbar_box);

    rows_chooser.set_range(2, 99);
    columns_chooser.set_range(2, 99);
	}

	protected override void ok_clicked()
	{
    bool restart = false;
		if(Settings.rows != this.rows_chooser.get_value_as_int())
		{
			Settings.rows = this.rows_chooser.get_value_as_int();
			this.rows_changed(this.rows_chooser.get_value_as_int());
      restart = true;
		}

		if(Settings.columns != this.columns_chooser.get_value_as_int())
		{
			Settings.columns = this.columns_chooser.get_value_as_int();
			this.columns_changed(this.columns_chooser.get_value_as_int());
      restart = true;
		}

		if(Settings.font != this.font_chooser.font_name)
		{
			Settings.font = this.font_chooser.font_name;
			this.font_changed(this.font_chooser.font_name);
		}

		if(Settings.scrollback_lines != this.scrollback_lines_chooser.get_value_as_int())
		{
			Settings.scrollback_lines = this.scrollback_lines_chooser.get_value_as_int();
			this.scrollback_lines_changed(this.scrollback_lines_chooser.get_value_as_int());
		}

		if(Settings.transparency != this.transparency_chooser.active)
		{
			Settings.transparency = this.transparency_chooser.active;
			this.transparency_changed(this.transparency_chooser.active);
		}

		if(Settings.show_scrollbar != this.show_scrollbar_chooser.active)
		{
			Settings.show_scrollbar = this.show_scrollbar_chooser.active;
			this.show_scrollbar_changed(this.show_scrollbar_chooser.active);
		}

    if (restart) {
      var dialog = new Gtk.MessageDialog(this, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, tr("Please restart application"));
      dialog.set_title(tr("Restart needed"));
      dialog.run();
      dialog.destroy();
    }
	}
}
