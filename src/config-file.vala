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

public class ConfigFile : GLib.KeyFile
{
    public ConfigFile()
    {
        try
        {
            this.load_from_file(this.filename(), KeyFileFlags.NONE);
        }
        catch(Error error)
        {
        }
    }

    public void write()
    {
        try
        {
            FileUtils.set_contents(this.filename(), this.to_data());
        }
        catch(FileError error)
        {
        }
    }

	private string filename()
	{
		string path = GLib.Environment.get_user_config_dir() + "/valaterm/";

		if(!FileUtils.test(path, FileTest.EXISTS))
		{
			DirUtils.create(path, 0700);
		}

		return path + "config.ini";
	}
}