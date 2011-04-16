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

public class Settings
{
	private static ConfigFile file;
	private static SettingKey terminal_font_key;
	private static SettingKey terminal_background_color_key;

	public static void init()
	{
		terminal_font_key = new SettingKey("Terminal", "Font", "FreeMono");
		terminal_background_color_key = new SettingKey("Terminal", "Background Color", "#ffffffffffff");
		file = new ConfigFile({ terminal_font_key });

		try
		{
			terminal_font_key.value = file.get_string(terminal_font_key.group,
													  terminal_font_key.name);
			terminal_background_color_key.value = file.get_string(terminal_background_color_key.group,
																  terminal_background_color_key.name);
		}
		catch(GLib.KeyFileError error)
		{
		}
	}

	public static unowned string terminal_font
	{
		get { return terminal_font_key.value; }
		set { terminal_font_key.save_value(file, value); }
	}

	public static unowned Gdk.Color terminal_background_color
	{
		get
		{
			Gdk.Color color;
			Gdk.Color.parse(terminal_background_color_key.value, out color);
			return color;
		}

		set
		{
			terminal_background_color_key.save_value(file, value.to_string());
		}
	}
}