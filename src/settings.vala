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
	private static SettingKey scrollback_lines_key;

	public static void init()
	{
		file = new ConfigFile();
		font_key = new SettingKey(file, "Terminal", "Font", "FreeMono 10");
		background_color_key = new SettingKey(file, "Terminal", "Background Color", "#ffffffffffff");
		foreground_color_key = new SettingKey(file, "Terminal", "Foreground Color", "#000000000000");
		scrollback_lines_key = new SettingKey(file, "Terminal", "Scrollback-Lines", "500");
	}

	public static unowned string font
	{
		get { return font_key.value; }
		set { font_key.save_value(value); }
	}

	public static unowned Gdk.Color background_color
	{
		get
		{
			Gdk.Color color;
			// FIXME: this function return a boolean to check if the function has failed.
			Gdk.Color.parse(background_color_key.value, out color);
			return color;
		}

		set
		{
			background_color_key.save_value(value.to_string());
		}
	}

	public static unowned Gdk.Color foreground_color
	{
		get
		{
			Gdk.Color color;
			// FIXME: this function return a boolean to check if the function has failed.
			Gdk.Color.parse(foreground_color_key.value, out color);
			return color;
		}

		set
		{
			foreground_color_key.save_value(value.to_string());
		}
	}

	public static unowned int scrollback_lines
	{
		get { return scrollback_lines_key.value.to_int(); }
		set { scrollback_lines_key.save_value(value.to_string()); }
	}
}