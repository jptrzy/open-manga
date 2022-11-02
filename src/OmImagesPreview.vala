[SingleInstance]
[GtkTemplate (ui = "/temp/OmImagesPreview.ui")]
class OmImagesPreview : Gtk.Box {
	[GtkChild] unowned Adw.ClampScrollable manhwaClamp;
	[GtkChild] unowned Gtk.Box manhwaImagesBox;

	public OmImagesPreview (Gtk.Box parent) {
		updateImages.begin ((obj, async_res) => {
			print("Hello");
		});
		print ("Change");
		setWidth (400);

		parent.append (this);
	}

	public void setWidth (int width) {
		manhwaClamp.set_maximum_size (width);
		manhwaClamp.set_tightening_threshold (width);
	}

	public async void updateImages () {
		var path = GLib.Environment.get_home_dir () + "/Downloaded Manga/The Archmage's Daughter/Chapter 10";

		try {
			var dir = Dir.open (path, 0);

			string? name = null;
			while ((name = dir.read_name ()) != null) {
				var image = new Gtk.Picture.for_filename (path + "/" + name);
				image.hexpand = true;
				manhwaImagesBox.append (image);

				print ("%s\n", name);

				Idle.add(updateImages.callback);
				yield;
			}
		} catch (GLib.FileError e) {
			print ("Can't find folder.\n");
		}
	}
}