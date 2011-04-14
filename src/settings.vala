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

	public static void init()
	{
		terminal_font_key = new SettingKey("Terminal", "Font", "FreeMono");
		file = new ConfigFile({ terminal_font_key });

		try
		{
			terminal_font_key.value = file.get_string(terminal_font_key.group,
													  terminal_font_key.name);
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
}