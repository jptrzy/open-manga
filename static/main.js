
let DEFAULT_PATH = "/home";
let PATH = "/home/jptrzy";

let [incrementElement] = document.querySelectorAll("#folders_list");

function sleep(milliseconds) {
	const date = Date.now();
	let currentDate = null;
	do {
		currentDate = Date.now();
	} while (currentDate - date < milliseconds);
}

function reload_files(path, save) {
	window.get_files(path).then(function(result){
		if (result.status != 0) {
			return;
		}

		let html = "";
		
		result.files.sort(function(a, b) {
			return a.name.localeCompare(b.name, undefined, {numeric: true, sensitivity: 'base'});
		})

		result.files.forEach(file => {
			html += "<li class='"+ (file.dir?"dir":"") +"'><span class='name'>"+file.name+"</span></li>"
		});

		document.getElementById("folders_list").innerHTML = html;
		incrementElement = document.querySelectorAll("#folders_list > li");
	
		if (save) {
			PATH = path;
		}
	});
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

			reload_files(path, true)
		}

		
	});

	reload_files(PATH, false);
});