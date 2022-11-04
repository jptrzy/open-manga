[SingleInstance]
class App : Adw.Application {
	public static OmFilesPreview filesPreview;
	public static OmImagesPreview imagePreview;
	public static Config config;

	public Adw.ApplicationWindow window;
	public Adw.Leaflet leadflet;

	public App () {
		Object (application_id: "net.jptrzy.open.manga",
		        flags: ApplicationFlags.FLAGS_NONE);

		print("\nNEW APP\n");
	}

	protected override void activate () {
		var builder = new Gtk.Builder.from_resource ("/ui/App.ui");

		window = (Adw.ApplicationWindow) builder.get_object ("window");
		window.application = this;

		var css_provider = new Gtk.CssProvider ();
		css_provider.load_from_resource ("style/App.css");
		Gtk.StyleContext.add_provider_for_display (window.get_display (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

		leadflet = (Adw.Leaflet) builder.get_object ("main_leaflet");

		var button = (Gtk.Button) builder.get_object ("main_back");
		button.clicked.connect ((handler) => {
			leadflet.navigate (Adw.NavigationDirection.BACK);
		});

		imagePreview = new OmImagesPreview ((Gtk.Box) builder.get_object ("image_preview_box"));
		filesPreview = new OmFilesPreview((Gtk.Box) builder.get_object ("files_preview_box"));

		window.present ();
	}

	public static int main (string[] args) {
		App.config = new Config ();
		var o = new App ().run (args);
		App.config.save ();
		return o;
	}
}