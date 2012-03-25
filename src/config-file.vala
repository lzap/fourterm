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

public class ConfigFile : GLib.Object
{
	private GLib.KeyFile file = new GLib.KeyFile();
	private bool has_errors = false;

    public ConfigFile()
    {
        try
        {
            this.file.load_from_file(this.filename(), KeyFileFlags.NONE);
        }
        catch(GLib.Error error)
        {
			if(!(error is GLib.KeyFileError.PARSE))
			{
				this.has_errors = true;
				// FIXME: Do something !
			}
        }
    }

	public string get_string_key(string group, string key, string default_value)
	{
		try
		{
		    return this.file.get_string(group, key);
		}
		catch(GLib.KeyFileError error)
		{
#if DEBUG
			this.display_get_key_error(error.message);
#endif
		}

		this.file.set_string(group, key, default_value);
		return default_value;
	}

	public int get_integer_key(string group, string key, int default_value)
	{
		try
		{
			return this.file.get_integer(group, key);
		}
		catch(GLib.KeyFileError error)
		{
#if DEBUG
			this.display_get_key_error(error.message);
#endif
		}

		this.file.set_integer(group, key, default_value);
		return default_value;
	}

	public bool get_boolean_key(string group, string key, bool default_value)
	{
		try
		{
			return this.file.get_boolean(group, key);
		}
		catch(GLib.KeyFileError error)
		{
#if DEBUG
			this.display_get_key_error(error.message);
#endif
		}

		this.file.set_boolean(group, key, default_value);
		return default_value;
	}

	public Gdk.Color get_color_key(string group, string key, Gdk.Color default_value)
	{
		try
		{
		    return Colors.parse(this.file.get_string(group, key));
		}
		catch(GLib.Error error)
		{
#if DEBUG
			this.display_get_key_error(error.message);
#endif
		}

		this.file.set_string(group, key, default_value.to_string());
		return default_value;
	}

    public void write()
    {
		if(!this.has_errors)
		{
			try
			{
				FileUtils.set_contents(this.filename(), this.file.to_data());
			}
			catch(GLib.FileError error)
			{
				// FIXME: Do something !
			}
		}
    }

	public void set_string(string group_name, string key, string str)
	{
		this.file.set_string(group_name, key, str);
	}

	public void set_boolean(string group_name, string key, bool value)
	{
		this.file.set_boolean(group_name, key, value);
	}

	public void set_integer(string group_name, string key, int value)
	{
		this.file.set_integer(group_name, key, value);
	}

	private string filename()
	{
		string path = GLib.Environment.get_user_config_dir() + "/fourterm/";
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

#if DEBUG
	private void display_get_key_error(string message)
	{
		GLib.stderr.printf("Error: %s. Using the default value.\n", message);
	}
#endif
}
