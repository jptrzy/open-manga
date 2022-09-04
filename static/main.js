
let DEFAULT_PATH = "/home";
let PATH = DEFAULT_PATH;

let [incrementElement] = document.querySelectorAll("#folders_list");

function reload_files(path){
	let res = true; // ERROR
	window.get_files(path).then(result => {
		if (result.status != 0) {
			return false;
		}

		let html = "";
		
		result.files.forEach(file => {
			html += "<li class='"+ (file.dir?"dir":"") +"'><span class='name'>"+file.name+"</span></li>"
		});

		document.getElementById("folders_list").innerHTML = html;
		incrementElement = document.querySelectorAll("#folders_list > li");
	
		res = false;
		return true;
	});
	return res;
}

document.addEventListener("DOMContentLoaded", () => {
	incrementElement.addEventListener("click", (event) => {

		var parent = event.target;

		while (parent!=null && parent.nodeName != "LI") {
			parent = parent.parentElement;
		}

		if (parent != null) {
			let name = parent.getElementsByClassName("name")[0];
			let path = PATH + "/" + name.innerText;

			if (reload_files(path)) {
				PATH = path;
			}
		}

		
	});

	reload_files(PATH);
});