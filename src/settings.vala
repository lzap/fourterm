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

public class Settings : GLib.Object
{
	private const string TERMINAL = "Terminal";
	private const string MENUBAR = "MenuBar";
	private const string FONT = "Font";
	private const string BACKGROUND_COLOR = "Background-Color";
	private const string FOREGROUND_COLOR = "Foreground-Color";
	private const string SCROLLBACK_LINES = "Scrollback-Lines";
	private const string TRANSPARENCY = "Transparency";
	private const string SHOW = "Show";

	public static string font
	{
		// FIXME: Why owned (only) here ???
		owned get
		{
			var file = new ConfigFile();
			return file.get_string_key(TERMINAL, FONT, "FreeMono 10");
		}

		set
		{
			var file = new ConfigFile();
			file.set_string(TERMINAL, FONT, value);
			file.write();
		}
	}

	public static Gdk.Color background_color
	{
		get
		{
			var file = new ConfigFile();
			Gdk.Color white = { 0, 0xffff, 0xffff, 0xffff };
			return file.get_color_key(TERMINAL, BACKGROUND_COLOR, white);
		}

		set
		{
			var file = new ConfigFile();
			file.set_string(TERMINAL, BACKGROUND_COLOR, value.to_string());
			file.write();
		}
	}

	public static Gdk.Color foreground_color
	{
		get
		{
			var file = new ConfigFile();
			Gdk.Color black = { 0, 0, 0, 0 };
			return file.get_color_key(TERMINAL, FOREGROUND_COLOR, black);
		}

		set
		{
			var file = new ConfigFile();
			file.set_string(TERMINAL, FOREGROUND_COLOR, value.to_string());
			file.write();
		}
	}

	public static int scrollback_lines
	{
		get
		{
			var file = new ConfigFile();
			return file.get_integer_key(TERMINAL, SCROLLBACK_LINES, 500);
		}

		set
		{
			var file = new ConfigFile();
			file.set_integer(TERMINAL, SCROLLBACK_LINES, value);
			file.write();
		}
	}

	public static bool transparency
	{
		get
		{
			var file = new ConfigFile();
			return file.get_boolean_key(TERMINAL, TRANSPARENCY, false);
		}

		set
		{
			var file = new ConfigFile();
			file.set_boolean(TERMINAL, TRANSPARENCY, value);
			file.write();
		}
	}

	public static bool show_menubar
	{
		get
		{
			var file = new ConfigFile();
			return file.get_boolean_key(MENUBAR, SHOW, true);
		}

		set
		{
			var file = new ConfigFile();
			file.set_boolean(MENUBAR, SHOW, value);
			file.write();
		}
	}
}