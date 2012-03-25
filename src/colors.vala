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
	const Gdk.Color[] colors_palette =
	{
		{ 0, 0x0707, 0x3636, 0x4242 }, // 0
		{ 0, 0xdcdc, 0x3232, 0x2f2f }, // 1
		{ 0, 0x8585, 0x9999, 0x0000 }, // 2
		{ 0, 0xb5b5, 0x8989, 0x0000 }, // 3
		{ 0, 0x2626, 0x8b8b, 0xd2d2 }, // 4
		{ 0, 0xd3d3, 0x3636, 0x8282 }, // 5
		{ 0, 0x2a2a, 0xa1a1, 0x9898 }, // 6
		{ 0, 0xeeee, 0xe8e8, 0xd5d5 }, // 7
		{ 0, 0x0000, 0x2b2b, 0x3636 }, // 8
		{ 0, 0xcbcb, 0x4b4B, 0x1616 }, // 9
		{ 0, 0x5858, 0x6e6e, 0x7575 }, // 10
		{ 0, 0x6565, 0x7b7b, 0x8383 }, // 11
		{ 0, 0x8383, 0x9494, 0x9696 }, // 12
		{ 0, 0x6c6c, 0x7171, 0xc4c4 }, // 13
		{ 0, 0x9393, 0xa1a1, 0xa1a1 }, // 14
		{ 0, 0xfdfd, 0xf6f6, 0xe3e3 }  // 15
	};

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
