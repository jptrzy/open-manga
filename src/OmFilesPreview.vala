class Entry : Gtk.Box {
	
}

[SingleInstance]
[GtkTemplate (ui = "/ui/OmFilesPreview.ui")]
class OmFilesPreview : Gtk.Box {
	[GtkChild] unowned Gtk.ListView list;
	[GtkChild] unowned Gtk.BuilderListItemFactory factory;

	public OmFilesPreview (Gtk.Box parent) {
		print ("Test");
		GLib.Type.from_instance (new Entry());
		var list_model = new GLib.ListStore(typeof (Entry));

		list_model.append (new Entry());
		list_model.append (new Entry());

		var model = new Gtk.SingleSelection(list_model);
		
		list.set_model (model);

		parent.append (this);
	}
}