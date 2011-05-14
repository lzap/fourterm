public class ImageMenuItem : Gtk.ImageMenuItem
{
	public ImageMenuItem(string image, string? label = null)
	{
		this.label = image;
		this.use_stock = true;

		if(label != null)
		{
			this.label = label;
		}
	}
}