[SingleInstance]
class ImagesPreview : GLib.Object {
	Gtk.ScrolledWindow scrolledWindow;
	Adw.ClampScrollable clamp;
	Gtk.Box imagesBox;

	public ImagesPreview (Gtk.Box parent) {
		var builder = new Gtk.Builder.from_resource ("/layout/images_preview.ui");

		scrolledWindow = (Gtk.ScrolledWindow) builder.get_object ("scrolled_window");
		clamp = (Adw.ClampScrollable) builder.get_object ("manhwa.clamp");
		imagesBox = (Gtk.Box) builder.get_object ("manhwa.box");

		updateImages ();
		setWidth (400);

		parent.append (scrolledWindow);
	}

	public void setWidth (int width) {
		clamp.set_maximum_size (width);
		clamp.set_tightening_threshold (width);
	}

	public void updateImages () {
		var path = GLib.Environment.get_home_dir () + "/Downloaded Manga/The Archmage's Daughter/Chapter 10";

		try {
			var dir = Dir.open (path, 0);

			string? name = null;
			while ((name = dir.read_name ()) != null) {
				var image = new Gtk.Picture.for_filename (path + "/" + name);
				image.hexpand = true;
				imagesBox.append (image);
			}
		} catch (GLib.FileError e) {
			print ("Can't find folder.\n");
		}
	}
}