//  [GtkTemplate (ui = "/ui/OmFilesPreviewEntry.ui")]
public class Entry : GLib.Object {
	public string name {set;get;default = "Kuba";}
	public string iconName {set;get;default = "media-record";}
}

[SingleInstance]
[GtkTemplate (ui = "/ui/OmFilesPreview.ui")]
class OmFilesPreview : Gtk.Box {
	[GtkChild] unowned Gtk.GridView list;

	[GtkCallback]
	public void activateCB (uint pos) {
		print ("%i\n", (int) pos);
	}

	public OmFilesPreview (Gtk.Box parent) {
		GLib.Type.from_instance (new Entry());
		var list_model = new GLib.ListStore(typeof (Entry));

		list_model.append (new Entry());
		list_model.append (new Entry());

		var model = new Gtk.NoSelection (list_model);
		
		list.set_model (model);

		parent.append (this);
	}
}