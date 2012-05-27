/****************************
** Copyright © 2012 Lukas Zapletal
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

public class GridManager {
  private int[,] indices;
  private int rows;
  private int cols;
  private int row;
  private int col;

  public GridManager(int rows, int cols)
    requires (rows > 0)
    requires (cols > 0) {
    indices = new int[rows, cols];
    int i = 0;
    for (int r = 0; r < rows; r++)
      for (int c = 0; c < cols; c++)
        indices[r, c] = i++;
    this.rows = rows;
    this.cols = cols;
    this.row = 0;
    this.col = 0;
  }

  public void right() {
    if (col + 1 < cols) col++;
    //GLib.stdout.printf("%d %d\n", row, col);
  }

  public void left() {
    if (col - 1 >= 0) col--;
    //GLib.stdout.printf("%d %d\n", row, col);
  }

  public void down() {
    if (row + 1 < rows) row++;
    //GLib.stdout.printf("%d %d\n", row, col);
  }

  public void up() {
    if (row - 1 >= 0) row--;
    //GLib.stdout.printf("%d %d\n", row, col);
  }

  public int index
  {
    get
    {
      return indices[row, col];
    }

    set
    {
      row = value / rows;
      col = value % cols;
    }
  }
}
