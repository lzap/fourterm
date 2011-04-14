public class SettingKey
{
	public string group { get; private set; }
	public string name { get; private set; }
	public string value { get; set; }

	public SettingKey(string group, string name, string value)
	{
		this.group = group;
		this.name = name;
		this.value = value;
	}
}