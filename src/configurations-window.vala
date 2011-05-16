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

public class ConfigurationsWindow : DefaultDialog
{
	private Gtk.FontButton font_chooser = new Gtk.FontButton();
	private Gtk.ColorButton background_color_chooser = new Gtk.ColorButton();
	private Gtk.ColorButton foreground_color_chooser = new Gtk.ColorButton();
	private Gtk.SpinButton scrollback_lines_chooser = new Gtk.SpinButton.with_range(-1, 10000, 1);

	public signal void font_changed(string font);
	public signal void background_color_changed(Gdk.Color color);
	public signal void foreground_color_changed(Gdk.Color color);
	public signal void scrollback_lines_changed(long lines);

	public ConfigurationsWindow(MainWindow parent_window)
	{
		this.title = _("ValaTerm Preferences");
		this.transient_for = parent_window;

		this.font_chooser.font_name = Settings.font;
		this.background_color_chooser.color = Settings.background_color;
		this.foreground_color_chooser.color = Settings.foreground_color;
		this.scrollback_lines_chooser.value = Settings.scrollback_lines;

		var font_box = new ParameterBox(_("Font:"), this.font_chooser);

		var background_color_box = new ParameterBox(_("Background color:"),
													this.background_color_chooser);

		var foreground_color_box = new ParameterBox(_("Foreground color:"),
													this.foreground_color_chooser);

		var scrollback_lines_box = new ParameterBox(_("Scrollback lines:"),
													this.scrollback_lines_chooser);

		this.vbox.pack_start(font_box);
		this.vbox.pack_start(background_color_box);
		this.vbox.pack_start(foreground_color_box);
		this.vbox.pack_start(scrollback_lines_box);
	}

	protected override void ok_clicked()
	{
		Settings.font = this.font_chooser.font_name;
		this.font_changed(Settings.font);

		Settings.background_color = this.background_color_chooser.color;
		this.background_color_changed(Settings.background_color);

		Settings.foreground_color = this.foreground_color_chooser.color;
		this.foreground_color_changed(Settings.foreground_color);

		Settings.scrollback_lines = this.scrollback_lines_chooser.get_value_as_int();
		this.scrollback_lines_changed(Settings.scrollback_lines);
	}
}