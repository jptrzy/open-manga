public class Entry : GLib.Object {
	public string name {set;get;default = "Kuba";}
	public string iconName {set;get;default = "media-record";}
	public string? path;

	public Entry(string name, string iconName, string? path) {
		this.name = name;
		this.iconName = iconName;
		this.path = path;

		OmFilesPreview.modelList.append (this);
	}

	public static Entry fromSimple(string path, string iconName) {
		return new Entry(GLib.Path.get_basename (path), iconName, path);
	}
}

[SingleInstance]
[GtkTemplate (ui = "/ui/OmFilesPreview.ui")]
class OmFilesPreview : Gtk.Box {
	public static GLib.ListStore modelList = new GLib.ListStore(typeof (Entry));

	string? rootPath = null;
	string subPath = GLib.Path.DIR_SEPARATOR_S;

	[GtkChild] unowned Gtk.GridView list;
	[GtkChild] unowned Adw.ToastOverlay toastOverlay;

	[GtkCallback]
	public void activateCB (uint pos) {
		var entry = (Entry) modelList.get_object (pos);

		if (rootPath == null) {
			if (entry.path == null) {
				if (entry.name == "New") {
					var fc = new Gtk.FileChooserDialog("Title", new App().window, 
						Gtk.FileChooserAction.SELECT_FOLDER,
						"Cancel", Gtk.ResponseType.CLOSE,
						"Open", Gtk.ResponseType.ACCEPT);
					fc.set_modal (true);
					fc.show();
					fc.response.connect ((res) => {
						if (res == Gtk.ResponseType.ACCEPT) {
								
							if (!tryAddFavorite(fc.get_file ().get_path ())) {
								toastOverlay.add_toast (new Adw.Toast("Couldn't add this folder for some reason. Check logs for more details."));
							}
							
							fc.close();
						} else if (res == Gtk.ResponseType.CLOSE) {
							fc.close();
						}
					});
				}
			} else {
				rootPath = entry.path;
				subPath = GLib.Path.DIR_SEPARATOR_S;

				updateList();
			}
		} else {
			if (entry.path == null) {
				var parent = GLib.File.new_for_path (subPath).get_parent ();

				if (parent == null) {
					rootPath = null;
					subPath = GLib.Path.DIR_SEPARATOR_S;
				} else {
					subPath = parent.get_path () + GLib.Path.DIR_SEPARATOR_S;
				}
			} else {
				if (Helper.isPathImage (entry.path)) {
					// Open Images Preview

					new App().leadflet.navigate (Adw.NavigationDirection.FORWARD);
					App.imagePreview.updateImages(rootPath + GLib.Path.DIR_SEPARATOR_S + subPath);
					App.imagePreview.window.vadjustment.value = 0;

					return;
				}
				subPath += entry.path + GLib.Path.DIR_SEPARATOR_S;
			}

			updateList();
		}
	}

	public void movePage() {
		
	}

	public bool tryAddFavorite(string path) {

		if (rootPath != null) {
			print ("Can't add favorite when not in favorite list.\n");
			return false;
		}

		foreach (string fav in new Config().favoriteList) {
			if (fav == path) {
				print ("This folder is in favorits.\n");
				return false;
			}
		}

		new Config().favoriteList.add(path);
		Entry.fromSimple(path, "folder");

		return true;
	}

	public void updateList () {
		OmFilesPreview.modelList.remove_all ();

		if (rootPath == null) { // List Favorite Folders
			new Entry("New", "list-add", null);

			foreach (string path in new Config().favoriteList) {
				Entry.fromSimple(path, "folder");
			}
		} else { // List Files in Current SubFolder inside RootFoler
			new Entry("Up", "pan-up", null);

			var dir = File.new_for_path(rootPath + GLib.Path.DIR_SEPARATOR_S + subPath);

			var e = dir.enumerate_children (GLib.FileAttribute.STANDARD_NAME,
				GLib.FileQueryInfoFlags.NOFOLLOW_SYMLINKS);

			GLib.FileInfo info;
			while ((info = e.next_file ()) != null) {
				var img = Helper.isPathImage(info.get_name ());
				if (info.get_file_type () == GLib.FileType.DIRECTORY || img) {
					Entry.fromSimple(info.get_name (), img ? "image" : "folder");
				}
			}
		}
	}

	public OmFilesPreview (Gtk.Box parent) {
		updateList();

		list.set_model (new Gtk.NoSelection (modelList));

		parent.append (this);
	}
}