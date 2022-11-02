[SingleInstance]
[GtkTemplate (ui = "/temp/OmFilesPreview.ui")]
class OmFilesPreview : Gtk.Box {
	//  public GLib.Path rootPath;

	public OmFilesPreview (Gtk.Box parent) {
		print ("Test");

		parent.append (this);
	}
}