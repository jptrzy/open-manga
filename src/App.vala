[SingleInstance]
class OpenManga : Adw.Application {
	public FilesPreview filesPreview;
	public ImagesPreview imagePreview;

	public Adw.Leaflet leadflet;

	public OpenManga () {
		Object (application_id: "net.jptrzy.open.manga",
		        flags: ApplicationFlags.FLAGS_NONE);
	}

	protected override void activate () {
		var builder = new Gtk.Builder.from_resource ("/layout/app.ui");

		var win = (Adw.ApplicationWindow) builder.get_object ("window");
		win.application = this;

		leadflet = (Adw.Leaflet) builder.get_object ("main.leaflet");
		leadflet.navigate (Adw.NavigationDirection.FORWARD);

		imagePreview = new ImagesPreview ((Gtk.Box) builder.get_object ("image_preview.box"));
		filesPreview = new FilesPreview((Gtk.Box) builder.get_object ("files_preview.box"));

		win.present ();
	}

	public static int main (string[] args) {
		return new OpenManga ().run (args);
	}
}