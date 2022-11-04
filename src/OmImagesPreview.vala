[SingleInstance]
[GtkTemplate (ui = "/ui/OmImagesPreview.ui")]
class OmImagesPreview : Gtk.Box {
	[GtkChild] public unowned Gtk.ScrolledWindow window;
	[GtkChild] public unowned Adw.ClampScrollable manhwaClamp;
	[GtkChild] unowned Gtk.Box manhwaImagesBox;

	GLib.List<Gtk.Widget> images = new GLib.List<Gtk.Widget>();

	public OmImagesPreview (Gtk.Box parent) {
		setWidth (400);

		parent.append (this);
	}

	public void setWidth (int width) {
		manhwaClamp.set_maximum_size (width);
		manhwaClamp.set_tightening_threshold (width);
	}

	public async void updateImages (string path) {
		try {
			foreach (var image in images) {
				manhwaImagesBox.remove(image);
			}
			
			images = new GLib.List<Gtk.Widget>();
			
			print ("%i\n", (int) images.length ());

			var dir = File.new_for_path(path);

			var e = dir.enumerate_children (GLib.FileAttribute.STANDARD_NAME,
				GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);

			GLib.FileInfo info;
			while ((info = e.next_file ()) != null) {
				if (Helper.isPathImage (info.get_name ())) {
					var image = new Gtk.Picture.for_filename (path + "/" + info.get_name ());
					image.hexpand = true;
					manhwaImagesBox.append (image);
					images.append (image);
	
					Idle.add(updateImages.callback);
					yield;
				}
			}
		} catch (GLib.Error e) {
			print ("Can't find folder or spcificly '%s'\n", e.message);
		}
	}
}