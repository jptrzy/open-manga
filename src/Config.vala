[SingleInstance]
class Config : GLib.Object {
	
	public int version {get; set;}
	public Gee.ArrayList<string> favoriteList = new Gee.ArrayList<string> ();

	public string[] favoritePaths { 
		owned get { 
			// For some **** reason. For shure something with space allocation.
			var list = favoriteList.to_array ();
			list.resize (list.length + list.length % 2);

			return list; 
		}

		set {
			favoriteList = new Gee.ArrayList<string>.wrap (value, null);
		}
	}

	private bool initiated = false;
	public Config() {
		if (!initiated) {
			{ // Load from file
				var p = new Json.Parser();

				p.load_from_file ("config.json");
			
				/*
					When JSON trys to write to newly created object values from parser
					it automaticly write them to this object,
					becouse it is [SingleInstance] and all objects are the same one.
				*/
				Json.gobject_deserialize (typeof(Config), p.get_root ());
			}

			print ("Config in version %i was loaded succesfully\n", version);
			
			initiated = true;
		}
	}
	
	public void save() {
		print ("TODO saving of config\n");
	}
}