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

public class SpinButton : Gtk.SpinButton
{
  public SpinButton(double value)
  {
    this.set_range(-1, 10000);
    this.set_increments(1, 1);
    this.value = value;
  }
}
