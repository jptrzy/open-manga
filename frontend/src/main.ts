import './style.css';
import './app.css';
import jQuery from "jquery";
window.$ = window.jQuery = jQuery;


// import logo from './assets/images/logo-universal.png';
import {ScanDir, UpdateConfig} from '../wailsjs/go/app/App';
import { app, config } from '../wailsjs/go/models';
import { EventsOn, Quit } from '../wailsjs/runtime/runtime';

let CONFIG:config.Config;

let PWD:string = "/home";

const SUP_IMG_FORMATS: string[] = [".png", ".webp", ".jpg", ".jpeg"];

function endsWithAny(suffixes: string[], string: string) {
    return suffixes.some(function (suffix) {
        return string.endsWith(suffix);
    });
}

function imgs_scroll(amount: number, time: number) {
	console.log(
		$('#imgs.tab').scrollTop()
	);

	$('#imgs.tab').stop().animate({
		scrollTop: ($('#imgs.tab').scrollTop()||0) - amount 
		}, time);
}

function update_width(size: number) {
	CONFIG.img_width = size;	
	$(':root').css("--imgs-width", size+"px");
}

function update_path(path:string) {
	PWD = path;
	$("#path").text(PWD);
}

let move_lock: boolean = false;
function move_dir(move:number) {
	if (move_lock) { return; }	
	move_lock = true;

	let i = PWD.lastIndexOf("/");
	let paths = [
		PWD.slice(0, i),
		PWD.slice(i+1)
	];

	ScanDir(paths[0]).then((result: app.ScanDirJSON) => {
		if (result.status != 0) { 
			move_lock = false;	
			return; 
		}

		result.files.sort(function(a, b) {
			return a.name.localeCompare(b.name, undefined, {numeric: true, sensitivity: 'base'});
		});	

		for (let i=0; i<result.files.length; i++) {
			if (result.files[i].name == paths[1]) {
				if (i+move > -1 && i+move < result.files.length) {
					window.scan_dir(paths[0]+"/"+result.files[i+move].name, true);
				} else {
					console.log("Can't go any further.");
				}

				break;
			}
		}
		move_lock = false;	
	});
}

window.switch_tab = function(id:string) {
	$(".select").removeClass("select");	

	$(".tab#" + id).addClass("select");
	$("#navbar > li[tab='"+id+"']").addClass("select");
}

window.scan_dir = function(path:string, save:boolean){
	try {
		ScanDir(path)
			.then((result: app.ScanDirJSON) => {
				if (result.status == 0) {
					result.files.sort(function(a, b) {
						return a.name.localeCompare(b.name, undefined, {numeric: true, sensitivity: 'base'});
					});	

					let imgs = "";
					let html = PWD == "/" ? "" : '<li class="dir">..</li>';

					result.files.forEach((file: app.File) => {
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
			}).catch((err:Error) => {
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

$(document).keydown((e:any) => {

	console.log(e.key);

	if (e.key == "-") { update_width(CONFIG.img_width - 10);
	} else if (e.key == "=") { update_width(CONFIG.img_width + 10);
	} else if (["h", "ArrowLeft"].includes(e.key)) { move_dir(-1);
	} else if (["l", "ArrowRight"].includes(e.key)) { move_dir(1);
	} else if (["k", "ArrowUp"].includes(e.key)) { imgs_scroll(-CONFIG.scroll_speed, 100);
	} else if (["j", "ArrowDown"].includes(e.key)) { imgs_scroll(-CONFIG.scroll_speed, 100);
	} else if (e.key == "1") { window.switch_tab("dirs");
	} else if (e.key == "2") { window.switch_tab("imgs");
	}
	return true;
});

$("#imgs.tab").on("wheel", function(e:any) {
	let delta:number = e.originalEvent.deltaY;

	imgs_scroll(CONFIG.scroll_speed * (delta>0?-1:1), 100/delta);

	e.preventDefault();
});

declare global {
    interface Window {
        scan_dir: (path:string, save:boolean) => void;
        switch_tab: (id:string) => void;
		  $: any;
        jQuery: any;
    }
}
