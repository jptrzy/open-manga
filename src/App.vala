[SingleInstance]
class OpenManga : Adw.Application {
	public OmFilesPreview filesPreview;
	public OmImagesPreview imagePreview;

	public Adw.Leaflet leadflet;

	public OpenManga () {
		Object (application_id: "net.jptrzy.open.manga",
		        flags: ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate () {
		var builder = new Gtk.Builder.from_resource ("/layout/App.ui");

		var win = (Adw.ApplicationWindow) builder.get_object ("window");
		win.application = this;

		var css_provider = new Gtk.CssProvider ();
		css_provider.load_from_resource ("style/App.css");
		Gtk.StyleContext.add_provider_for_display (win.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

		leadflet = (Adw.Leaflet) builder.get_object ("main.leaflet");
		leadflet.navigate (Adw.NavigationDirection.FORWARD);

		var button = (Gtk.Button) builder.get_object ("main.back");
		button.clicked.connect ((handler) => {
			leadflet.navigate (Adw.NavigationDirection.BACK);
		});

		imagePreview = new OmImagesPreview ((Gtk.Box) builder.get_object ("image_preview.box"));
		filesPreview = new OmFilesPreview((Gtk.Box) builder.get_object ("files_preview.box"));

		win.present ();
	}

	public static int main (string[] args) {
		return new OpenManga ().run (args);
	}
}