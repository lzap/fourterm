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

	private static const string TERMINAL_FONT_GROUP = "Terminal";
	private static const string TERMINAL_FONT_NAME = "Font";
	private static string terminal_font_value;

	public static void init()
	{
		terminal_font_value = "FreeMono";
		file = new ConfigFile(
			{
				TERMINAL_FONT_GROUP, TERMINAL_FONT_NAME, terminal_font_value
			});

		try
		{
			terminal_font_value = file.get_string(TERMINAL_FONT_GROUP,
												  TERMINAL_FONT_NAME);
		}
		catch(GLib.KeyFileError error)
		{
		}
	}

	public static unowned string terminal_font
	{
		get
		{
			return terminal_font_value;
		}

		set
		{
			if(value != terminal_font_value)
			{
				terminal_font_value = value;

				file.set_string(TERMINAL_FONT_GROUP, TERMINAL_FONT_NAME, value);
				file.write();
			}
		}
	}
}