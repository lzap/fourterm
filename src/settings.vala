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
	public static void init()
	{
		var file = new ConfigFile();

		try
		{
			Settings._terminal_font = file.get_string("Terminal", "Font");
		}
		catch(GLib.KeyFileError error)
		{
		}
	}

	private static string? _terminal_font = null;
	public static unowned string terminal_font
	{
		get
		{
			if(Settings._terminal_font == null)
			{
				return "FreeMono";
			}

			return Settings._terminal_font;
		}

		set
		{
			Settings._terminal_font = value;

			var file = new ConfigFile();
			file.set_string("Terminal", "Font", value);
			file.write();
		}
	}
}