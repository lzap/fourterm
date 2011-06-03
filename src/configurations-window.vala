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
	private FontButton font_chooser = new FontButton(Settings.font);
	private ColorButton background_color_chooser = new ColorButton(Settings.background_color);
	private ColorButton foreground_color_chooser = new ColorButton(Settings.foreground_color);
	private SpinButton scrollback_lines_chooser = new SpinButton(Settings.scrollback_lines);
	private CheckButton transparency_chooser = new CheckButton(Settings.transparency);

	public signal void font_changed(string font);
	public signal void background_color_changed(Gdk.Color color);
	public signal void foreground_color_changed(Gdk.Color color);
	public signal void scrollback_lines_changed(long lines);
	public signal void transparency_changed(bool tranparency);

	public ConfigurationsWindow(MainWindow parent_window)
	{
		this.title = _("ValaTerm Preferences");
		this.transient_for = parent_window;

		var font_box = new ParameterBox(_("Font:"), this.font_chooser);

		var background_color_box = new ParameterBox(_("Background color:"),
													this.background_color_chooser);

		var foreground_color_box = new ParameterBox(_("Foreground color:"),
													this.foreground_color_chooser);

		var scrollback_lines_box = new ParameterBox(_("Scrollback lines:"),
													this.scrollback_lines_chooser);

		var transparency_box = new ParameterBox(_("Transparency:"),
												this.transparency_chooser);

		this.vbox.pack_start(font_box);
		this.vbox.pack_start(background_color_box);
		this.vbox.pack_start(foreground_color_box);
		this.vbox.pack_start(scrollback_lines_box);
		this.vbox.pack_start(transparency_box);
	}

	protected override void ok_clicked()
	{
		Settings.font = this.font_chooser.font_name;
		this.font_changed(this.font_chooser.font_name);

		Settings.background_color = this.background_color_chooser.color;
		this.background_color_changed(this.background_color_chooser.color);

		Settings.foreground_color = this.foreground_color_chooser.color;
		this.foreground_color_changed(this.foreground_color_chooser.color);

		Settings.scrollback_lines = this.scrollback_lines_chooser.get_value_as_int();
		this.scrollback_lines_changed(this.scrollback_lines_chooser.get_value_as_int());

		Settings.transparency = this.transparency_chooser.active;
		this.transparency_changed(this.transparency_chooser.active);
	}
}