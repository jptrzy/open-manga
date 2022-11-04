//  [GtkTemplate (ui = "/ui/OmFilesPreviewEntry.ui")]
public class Entry : GLib.Object {
	public string name {set;get;default = "Kuba";}
	public string iconName {set;get;default = "media-record";}
	public GLib.File? path;

	public Entry(string name, string iconName, GLib.File? path) {
		this.name = name;
		this.iconName = iconName;
		this.path = path;

		OmFilesPreview.modelList.append (this);
	}
}

[SingleInstance]
[GtkTemplate (ui = "/ui/OmFilesPreview.ui")]
class OmFilesPreview : Gtk.Box {
	public static GLib.ListStore modelList = new GLib.ListStore(typeof (Entry));

	GLib.File? rootPath = null;

	[GtkChild] unowned Gtk.GridView list;

	[GtkCallback]
	public void activateCB (uint pos) {
		print ("%i - %s\n", (int) pos, ((Entry) modelList.get_object (pos)).name);

		var entry = (Entry) modelList.get_object (pos);

		if (entry.path == null && entry.name == "New") {
			print ("Create New\n");
			var fc = new Gtk.FileChooserDialog("Title", new OpenManga().window, 
				Gtk.FileChooserAction.SELECT_FOLDER,
				"Cancel", Gtk.ResponseType.CLOSE,
				"Open", Gtk.ResponseType.ACCEPT);
			fc.set_modal (true);
			fc.show();
			fc.response.connect ((res) => {
				if (res == Gtk.ResponseType.ACCEPT) {
					print ("%s\n", fc.get_file ().get_path ());
					
					print ("%b\n", tryAddFavorite(fc.get_file ().get_path ()));
					
					fc.close();
				} else if (res == Gtk.ResponseType.CLOSE) {
					fc.close();
				}
			});
		}
	}

	public bool tryAddFavorite(string path) {

		//  foreach (string f in new Config().favoriteList) {
		//  	if (f == path) {
		//  		return false;
		//  	}
		//  }

		return true;
	}

	public OmFilesPreview (Gtk.Box parent) {
		print ("%i\n", new Config().favoriteList.size);
		foreach (string f in new Config().favoriteList) {

			new Entry("Help_", "null", null);
		}

		new Entry("New", "list-add", null);

		list.set_model (new Gtk.NoSelection (modelList));

		parent.append (this);
	}
}