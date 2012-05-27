/****************************
** Copyright © 2011 Jacques-Pascal Deplaix, Lukas Zapletal
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
  /* Groups */
  private const string TERMINAL = "Terminal";
  private const string MENUBAR = "MenuBar";

  /* Keys */
  private const string FONT = "Font";
  private const string SCROLLBACK_LINES = "Scrollback-Lines";
  private const string TRANSPARENCY = "Transparency";
  private const string DAYLIGHT_PALETTE = "Daylight-Palette";
  private const string SHOW = "Show";
  private const string SHOW_SCROLLBAR = "Show-Scrollbar";
  private const string ROWS = "Rows";
  private const string COLUMNS = "Columns";

  private static unowned ConfigFile file;

  public static void init(ConfigFile file)
  {
    Settings.file = file;
  }

  public static string font
  {
    // FIXME: Why owned (only) here ???
    owned get
    {
      return file.get_string_key(TERMINAL, FONT, "Terminus 10");
    }

    set
    {
      file.set_string(TERMINAL, FONT, value);
      file.write();
    }
  }

  public static int scrollback_lines
  {
    get
    {
      return file.get_integer_key(TERMINAL, SCROLLBACK_LINES, 500);
    }

    set
    {
      file.set_integer(TERMINAL, SCROLLBACK_LINES, value);
      file.write();
    }
  }

  public static bool daylight_palette
  {
    get
    {
      return file.get_boolean_key(TERMINAL, DAYLIGHT_PALETTE, false);
    }

    set
    {
      file.set_boolean(TERMINAL, DAYLIGHT_PALETTE, value);
      file.write();
    }
  }

  public static bool transparency
  {
    get
    {
      return file.get_boolean_key(TERMINAL, TRANSPARENCY, false);
    }

    set
    {
      file.set_boolean(TERMINAL, TRANSPARENCY, value);
      file.write();
    }
  }

  public static bool show_menubar
  {
    get
    {
      return file.get_boolean_key(MENUBAR, SHOW, true);
    }

    set
    {
      file.set_boolean(MENUBAR, SHOW, value);
      file.write();
    }
  }

  public static bool show_scrollbar
  {
    get
    {
      return file.get_boolean_key(TERMINAL, SHOW_SCROLLBAR, true);
    }

    set
    {
      file.set_boolean(TERMINAL, SHOW_SCROLLBAR, value);
      file.write();
    }
  }

  public static int rows
  {
    get
    {
      int v = file.get_integer_key(TERMINAL, ROWS, 2);
      if (v < 2) v = 2;
      return v;
    }

    set
    {
      file.set_integer(TERMINAL, ROWS, value);
      file.write();
    }
  }

  public static int columns
  {
    get
    {
      int v = file.get_integer_key(TERMINAL, COLUMNS, 2);
      if (v < 2) v = 2;
      return v;
    }

    set
    {
      file.set_integer(TERMINAL, COLUMNS, value);
      file.write();
    }
  }
}
