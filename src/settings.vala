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
	private static SettingKey font_key;
	private static SettingKey background_color_key;
	private static SettingKey foreground_color_key;

	public static void init()
	{
		font_key = new SettingKey("Terminal", "Font", "FreeMono");
		background_color_key = new SettingKey("Terminal", "Background Color", "#ffffffffffff");
		foreground_color_key = new SettingKey("Terminal", "Foreground Color", "#000000000000");
		file = new ConfigFile({ font_key, background_color_key });

		try
		{
			font_key.value = file.get_string(font_key.group,
											 font_key.name);
			background_color_key.value = file.get_string(background_color_key.group,
														 background_color_key.name);
			foreground_color_key.value = file.get_string(foreground_color_key.group,
														 foreground_color_key.name);
		}
		catch(GLib.KeyFileError error)
		{
		}
	}

	public static unowned string font
	{
		get { return font_key.value; }
		set { font_key.save_value(file, value); }
	}

	public static unowned Gdk.Color background_color
	{
		get
		{
			Gdk.Color color;
			Gdk.Color.parse(background_color_key.value, out color);
			return color;
		}

		set
		{
			background_color_key.save_value(file, value.to_string());
		}
	}

	public static unowned Gdk.Color foreground_color
	{
		get
		{
			Gdk.Color color;
			Gdk.Color.parse(foreground_color_key.value, out color);
			return color;
		}

		set
		{
			foreground_color_key.save_value(file, value.to_string());
		}
	}
}