// using GLib;
// using Gtk;



int main (string[] args) {
	var path = GLib.Environment.get_home_dir () + "/Downloaded Manga/The Archmage's Daughter/Chapter 1";

	var app = new Adw.Application (
	                               "net.jptrzy.open.manga.App",
	                               ApplicationFlags.FLAGS_NONE
	);

	app.activate.connect (() => {
		// TODO from resources
		var builder = new Gtk.Builder.from_resource ("/layout/app.ui");
		var win = (Adw.ApplicationWindow) builder.get_object ("window");
		win.application = app;

		var clamp = (Adw.ClampScrollable) builder.get_object ("preview.manhwa.clamp");
		clamp.set_maximum_size (500);
		var box = (Gtk.Box) builder.get_object ("preview.manhwa.box");

		try {
			var dir = Dir.open (path, 0);

			string? name = null;
			while ((name = dir.read_name ()) != null) {
				var image = new Gtk.Picture.for_filename (path + "/" + name);
				image.hexpand = true;
				box.append (image);
			}
		} catch (GLib.FileError e) {
			print ("Can't find folder.\n");
		}

		win.present ();
	});
	return app.run (args);
}