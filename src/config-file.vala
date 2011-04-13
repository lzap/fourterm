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
    public ConfigFile(string[] default_settings)
    {
        try
        {
            this.load_from_file(this.filename(), KeyFileFlags.NONE);
        }
        catch(GLib.Error error)
        {
			if(error is GLib.FileError.NOENT)
			{
				this.set_string(default_settings[0], default_settings[1],
								default_settings[2]);
			}
        }
    }

    public void write()
    {
        try
        {
            FileUtils.set_contents(this.filename(), this.to_data());
        }
        catch(GLib.FileError error)
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

		string file = path + "config.ini";

		if(!FileUtils.test(file, FileTest.EXISTS))
		{
			// Create the file
			FileStream.open(file, "w");
		}

		return path + "config.ini";
	}
}