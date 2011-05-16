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
        catch(GLib.Error error)
        {
			// FIXME: Do something !
        }
    }

	public string get_string_key(string group, string key, string default_value)
	{
		try
		{
		    return this.get_string(group, key);
		}
		catch(GLib.KeyFileError error)
		{
			// FIXME: Do something !
			this.set_string(group, key, default_value);
			return default_value;
		}
	}

	public int get_integer_key(string group, string key, int default_value)
	{
		try
		{
			return this.get_integer(group, key);
		}
		catch(GLib.KeyFileError error)
		{
			// FIXME: Do something !
			this.set_integer(group, key, default_value);
			return default_value;
		}
	}

	public Gdk.Color get_color_key(string group, string key, Gdk.Color default_value)
	{
		try
		{
		    return Colors.parse(this.get_string(group, key));
		}
		catch(GLib.KeyFileError error)
		{
			// FIXME: Do something !
			this.set_string(group, key, default_value.to_string());
			return default_value;
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
			// FIXME: Do something !
        }
    }

	private string filename()
	{
		string path = GLib.Environment.get_user_config_dir() + "/valaterm/";
		this.verify_dir(path);

		string file = path + "config.ini";
		this.verify_file(file);

		return file;
	}

	private void verify_dir(string dir)
	{
		if(!FileUtils.test(dir, FileTest.EXISTS))
		{
			// Create the dir
			DirUtils.create(dir, 0700);
		}
	}

	private void verify_file(string file)
	{
		if(!FileUtils.test(file, FileTest.EXISTS))
		{
			// Create the file
			FileStream.open(file, "w");
		}
	}
}