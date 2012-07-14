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

public class About : Gtk.AboutDialog
{
  const string[] all_authors = {
    "Jacques-Pascal Deplaix <jp.deplaix@gmail.com>",
    "Lukas Zapletal <http://lukas.zapletalovi.com>",
    "" };

  private About(MainWindow parent_window)
  {
    try {
      this.transient_for = parent_window;
      this.program_name = "FourTerm";
      this.version = Config.VERSION;
      this.copyright = "Copyright © 2010 Jacques-Pascal Deplaix\n" +
        "Copyright © 2012 Lukas Zapletal";
      this.comments = tr("Lightweight split-screen terminal emulator with vim key mappings");
      this.logo = new Gdk.Pixbuf.from_file(Path.build_filename(Config.DATA_DIR, "/icons/hicolor/128x128/apps/fourterm.png"));
      this.website = "https://github.com/lzap/fourterm";
      this.authors = all_authors;
      this.license = "Copyright © 2011 Jacques-Pascal Deplaix\n" +
        "Copyright © 2012 Lukas Zapletal" +
        "\n" +
        "\nFourTerm is free software: you can redistribute it and/or modify" +
        "\nit under the terms of the GNU General Public License as published by" +
        "\nthe Free Software Foundation, either version 3 of the License, or" +
        "\n(at your option) any later version." +
        "\n" +
        "\nThis program is distributed in the hope that it will be useful," +
        "\nbut WITHOUT ANY WARRANTY; without even the implied warranty of" +
        "\nMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the" +
        "\nGNU General Public License for more details." +
        "\n" +
        "\nYou should have received a copy of the GNU General Public License" +
        "\nalong with this program.  If not, see <http://www.gnu.org/licenses/>.";
    } catch (GLib.Error error) {
#if DEBUG
      this.display_get_key_error(error.message);
#endif
    }
  }

  public static void display(MainWindow parent_window)
  {
    var window = new About(parent_window);
    window.run();
    window.destroy();
  }
}
