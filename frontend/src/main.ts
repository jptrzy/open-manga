import './style.css';
import './app.css';
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;


// import logo from './assets/images/logo-universal.png';
import {ScanDir} from '../wailsjs/go/main/App';
import { main } from '../wailsjs/go/models';

let PWD:string = "/home";
const SUP_IMG_FORMATS: string[] = [".png", ".webp", ".jpg", ".jpeg"];

function endsWithAny(suffixes: string[], string: string) {
    return suffixes.some(function (suffix) {
        return string.endsWith(suffix);
    });
}

function update_path(path:string) {
	PWD = path;
	$("#path").text(PWD);
}

window.switch_tab = function(id:string) {
	$(".select").removeClass("select");	

	$(".tab#" + id).addClass("select");
	$("#navbar > li[tab='"+id+"']").addClass("select");
}

window.scan_dir = function(path:string, save:boolean){
	try {
		ScanDir(path)
			.then((result: main.ScanDirJSON) => {
				if (result.status == 0) {
					result.files.sort(function(a, b) {
						return a.name.localeCompare(b.name, undefined, {numeric: true, sensitivity: 'base'});
					});	

					let imgs = "";
					let html = PWD == "/" ? "" : '<li class="dir">..</li>';

					result.files.forEach((file: main.File) => {
						let is_dir = endsWithAny(SUP_IMG_FORMATS, file.name);

						if (is_dir) {
							imgs += `<img src="${path+"/"+file.name}" alt="${file.name}"/>`;
						}

						html += `<li class="${file.dir ? "dir " : ""}${is_dir ? "img" : ""}">${file.name}</li>`;
					});

					$("#dirs").html(html);
					$("#imgs").html(imgs);
					
					if (save) {
						update_path(path);
					}
				}
			}).catch((err) => {
				console.error(err);
			})
	} catch (err) {
		console.error(err);
	}	    
}


window.switch_tab("dirs");
update_path(PWD);
window.scan_dir(PWD, true);


$(document).on('click', "li.dir", function(e) {
	let path:string = PWD + "/" + $(this).text();

	if ($(this).text() === "..") {
		path = path.slice(0, PWD.lastIndexOf("/"));
	}

	console.log($(this).text(), path, e);

	window.scan_dir(path, true);
});

$(document).on('click', "#navbar > li", function() {
	window.switch_tab($(this).attr("tab")!);
});

declare global {
    interface Window {
        scan_dir: (path:string, save:boolean) => void;
        switch_tab: (id:string) => void;
		  $: any;
        jQuery: any;
    }
}
