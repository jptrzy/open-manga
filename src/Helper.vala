namespace Helper {

	public static string getExt(string path) {
		return path.slice (path.last_index_of_char ('.')+1,  path.length);
	}

	public const string[] IMAGES_EXT = {"jpg", "jpeg", "png", "webp"};
	public static bool isExtImage(string ext) {
		return ext in IMAGES_EXT;
	}

	public static bool isPathImage(string path) {
		return isExtImage(getExt(path));
	}
}