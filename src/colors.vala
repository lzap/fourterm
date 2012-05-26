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

namespace Colors
{
  const Gdk.Color[] solarized_dark_palette =
  {
    { 0, 0x0707, 0x3636, 0x4242 }, // 0  S_base02
    { 0, 0xdcdc, 0x3232, 0x2f2f }, // 1  S_red
    { 0, 0x8585, 0x9999, 0x0000 }, // 2  S_green
    { 0, 0xb5b5, 0x8989, 0x0000 }, // 3  S_yellow
    { 0, 0x2626, 0x8b8b, 0xd2d2 }, // 4  S_blue
    { 0, 0xd3d3, 0x3636, 0x8282 }, // 5  S_magenta
    { 0, 0x2a2a, 0xa1a1, 0x9898 }, // 6  S_cyan
    { 0, 0xeeee, 0xe8e8, 0xd5d5 }, // 7  S_base2
    { 0, 0x0000, 0x2b2b, 0x3636 }, // 8  S_base03
    { 0, 0xcbcb, 0x4b4B, 0x1616 }, // 9  S_orange
    { 0, 0x5858, 0x6e6e, 0x7575 }, // 10 S_base01
    { 0, 0x6565, 0x7b7b, 0x8383 }, // 11 S_base00
    { 0, 0x8383, 0x9494, 0x9696 }, // 12 S_base0
    { 0, 0x6c6c, 0x7171, 0xc4c4 }, // 13 S_violet
    { 0, 0x9393, 0xa1a1, 0xa1a1 }, // 14 S_base1
    { 0, 0xfdfd, 0xf6f6, 0xe3e3 }  // 15 S_base3
  };

  const Gdk.Color[] solarized_light_palette =
  {
    { 0, 0xeeee, 0xe8e8, 0xd5d5 }, // 0  S_base2
    { 0, 0xdcdc, 0x3232, 0x2f2f }, // 1  S_red
    { 0, 0x8585, 0x9999, 0x0000 }, // 2  S_green
    { 0, 0xb5b5, 0x8989, 0x0000 }, // 3  S_yellow
    { 0, 0x2626, 0x8b8b, 0xd2d2 }, // 4  S_blue
    { 0, 0xd3d3, 0x3636, 0x8282 }, // 5  S_magenta
    { 0, 0x2a2a, 0xa1a1, 0x9898 }, // 6  S_cyan
    { 0, 0x0707, 0x3636, 0x4242 }, // 7  S_base02
    { 0, 0xfdfd, 0xf6f6, 0xe3e3 }, // 8  S_base3
    { 0, 0xcbcb, 0x4b4B, 0x1616 }, // 9  S_orange
    { 0, 0x9393, 0xa1a1, 0xa1a1 }, // 10 S_base1
    { 0, 0x8383, 0x9494, 0x9696 }, // 11 S_base0
    { 0, 0x6565, 0x7b7b, 0x8383 }, // 12 S_base00
    { 0, 0x6c6c, 0x7171, 0xc4c4 }, // 13 S_violet
    { 0, 0x5858, 0x6e6e, 0x7575 }, // 14 S_base01
    { 0, 0x0000, 0x2b2b, 0x3636 }  // 15 S_base03
  };

	public Gdk.Color[] active_palette()
  {
    if (Settings.daylight_palette)
      return solarized_light_palette;
    else
      return solarized_dark_palette;
  }

	public Gdk.Color active_background_color()
  {
    if (Settings.daylight_palette)
      return solarized_light_palette[8];
    else
      return solarized_dark_palette[8];
  }

	public Gdk.Color active_foreground_color()
  {
    if (Settings.daylight_palette)
      return solarized_light_palette[12];
    else
      return solarized_dark_palette[12];
  }

	public Gdk.Color active_highlight_background_color()
  {
    Gdk.Color c;
    if (Settings.daylight_palette)
      c = { 0, 0xeded, 0xe6e6, 0xd3d3 }; // S_base3 - 0x10
    else
      c = { 0, 0x0000, 0x1b1b, 0x2626 }; // S_base03 + 0x10
    return c;
  }

	public Gdk.Color parse(string color) throws GLib.ConvertError
	{
		Gdk.Color value;

		if(!Gdk.Color.parse(color, out value))
		{
			throw new GLib.ConvertError.FAILED("\"%s\" couldn't be parsed as color", color);
		}

		return value;
	}
}
