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

public class SettingKey
{
	public string group { get; private set; }
	public string name { get; private set; }
	public string value { get; set; }

	private unowned ConfigFile file;

	public SettingKey(ConfigFile file, string group, string name, string value)
	{
		this.file = file;
		this.group = group;
		this.name = name;
		this.value = value;

		try
		{
			this.value = this.file.get_string(this.group, this.name);
		}
		catch(GLib.KeyFileError error)
		{
			// Use default values
			this.file.set_string(this.group, this.name, this.value);
		}
	}

	public void save_value(string value)
	{
		if(value != this.value)
		{
			this.value = value;

			this.file.set_string(this.group, this.name, this.value);
			this.file.write();
		}
	}
}