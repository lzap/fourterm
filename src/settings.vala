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
xo** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program.  If not, see <http://www.gnu.org/licenses/>.
****************************/

public class Settings
{
	private static ConfigFile file;

	private const string TERMINAL = "Terminal";
	private const string FONT = "Font";
	private const string BACKGROUND_COLOR = "Background-Color";
	private const string FOREGROUND_COLOR = "Foreground-Color";
	private const string SCROLLBACK_LINES = "Scrollback-Lines";

	private delegate void SetDefaultValue();

	public static void init()
	{
		file = new ConfigFile();
		init_value(TERMINAL, FONT, () => font = "FreeMono 10");
		init_value(TERMINAL, BACKGROUND_COLOR, () => background_color = Colors.white);
		init_value(TERMINAL, FOREGROUND_COLOR, () => foreground_color = Colors.black);
		init_value(TERMINAL, SCROLLBACK_LINES, () => scrollback_lines = 500);
	}

	private static void init_value(string group, string name, SetDefaultValue error_func)
	{
		if(file.test_key(group, name) != true)
		{
			error_func();
		}
	}

	public static string font
	{
		// FIXME: Why owned (only) here ???
		owned get { return file.get_string_key(TERMINAL, FONT); }
		set { file.set_string(TERMINAL, FONT, value); file.write(); }
	}

	public static Gdk.Color background_color
	{
		get { return Colors.parse(file.get_string_key(TERMINAL, BACKGROUND_COLOR)); }
		set { file.set_string(TERMINAL, BACKGROUND_COLOR, value.to_string()); file.write(); }
	}

	public static Gdk.Color foreground_color
	{
		get { return Colors.parse(file.get_string_key(TERMINAL, FOREGROUND_COLOR)); }
		set { file.set_string(TERMINAL, FOREGROUND_COLOR, value.to_string()); file.write(); }
	}

	public static int scrollback_lines
	{
		get { return file.get_integer_key(TERMINAL, SCROLLBACK_LINES); }
		set { file.set_integer(TERMINAL, SCROLLBACK_LINES, value); file.write(); }
	}
}