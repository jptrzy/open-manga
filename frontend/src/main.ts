import './style.css';
import './app.css';
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;


// import logo from './assets/images/logo-universal.png';
import {ScanDir, UpdateConfig} from '../wailsjs/go/main/App';
import { main, config } from '../wailsjs/go/models';
import { EventsOn, Quit } from '../wailsjs/runtime/runtime';

let CONFIG:config.Config;

let PWD:string = "/home";
const SUP_IMG_FORMATS: string[] = [".png", ".webp", ".jpg", ".jpeg"];

function endsWithAny(suffixes: string[], string: string) {
    return suffixes.some(function (suffix) {
        return string.endsWith(suffix);
    });
}

function update_width(size: number) {
	CONFIG.img_width = size;	
	$(':root').css("--imgs-width", size+"px");
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
						if (!CONFIG.show_hidden_files && file.name.startsWith(".")) {
							return;
						}

						let is_img = endsWithAny(SUP_IMG_FORMATS, file.name);

						if (is_img) {
							imgs += `<img src="${path+"/"+file.name}" alt="${file.name}"/>`;
						}

						html += `<li class="${file.dir ? "dir " : ""}${is_img ? "img" : ""}">${file.name}</li>`;
					});

					$("#dirs").html(html);
					$("#imgs").html(imgs);
					
					if (save) {
						update_path(path);
					}
					console.log("END Promis");
				}
			}).catch((err) => {
				console.error(err);
			})
	} catch (err) {
		console.error(err);
	}	   
	
	console.log("END Fun");
}


UpdateConfig(new config.Config(), false).then((config:config.Config)=>{
	CONFIG = config;
	PWD = CONFIG.last_dir;

	window.switch_tab("dirs");
	update_path(PWD);
	update_width(CONFIG.img_width);	
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

	// Ensure that config is saved
	EventsOn("before_close", ()=>{
		CONFIG.last_dir = PWD;

		UpdateConfig(CONFIG, true)
			.then(()=>{
				Quit();
			});
	});
});

declare global {
    interface Window {
        scan_dir: (path:string, save:boolean) => void;
        switch_tab: (id:string) => void;
		  $: any;
        jQuery: any;
    }
}
