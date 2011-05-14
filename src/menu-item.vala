public class MenuItem : Gtk.MenuItem
{
	public MenuItem(string label, Gtk.MenuItem[] items)
	{
		this.label = label;

		var submenu = new Gtk.Menu();
		this.set_submenu(submenu);

		foreach(Gtk.MenuItem item in items)
		{
			submenu.append(item);
		}
	}
}