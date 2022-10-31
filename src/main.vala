using GLib;
using Gtk;



int main (string[] args) {
	var path = GLib.Environment.get_home_dir () + "/Downloaded Manga/The Archmage's Daughter/Chapter 1";

	var app = new Gtk.Application (
	                               "net.jptrzy.open.manga.App",
	                               ApplicationFlags.FLAGS_NONE
	);

	app.activate.connect (() => {
		var win = new Gtk.ApplicationWindow (app);

		var css_provider = new Gtk.CssProvider ();
		css_provider.load_from_resource ("styles.css");
		Gtk.StyleContext.add_provider_for_display (win.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

		var scroll = new Gtk.ScrolledWindow ();

		var clamp = new Adw.Clamp ();
		clamp.set_maximum_size (500);

		var box = new Box (Gtk.Orientation.VERTICAL, 0);
		var view = new Viewport (null, scroll.vadjustment);
		view.vscroll_policy = ScrollablePolicy.NATURAL;

		try {
			var dir = Dir.open (path, 0);

			string? name = null;
			while ((name = dir.read_name ()) != null) {
				var image = new Gtk.Picture.for_filename (path + "/" + name);
				// image.hexpand = true;
				box.append (image);
			}
		} catch (GLib.FileError e) {
			print ("Can't find folder.\n");
		}

		view.child = box;
		scroll.child = view;
		clamp.child = scroll;
		win.child = clamp;
		win.present ();
	});
	return app.run (args);
}