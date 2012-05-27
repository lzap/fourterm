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

public class ParameterBox : Gtk.HBox
{
  public ParameterBox(string label, Gtk.Widget chooser_widget)
  {
    this.homogeneous = true;
    this.spacing = 10;

    this.pack_start(new Gtk.Label(label));
    this.pack_start(chooser_widget);
  }
}
