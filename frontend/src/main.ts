import './style.css';
import './app.css';

import jQuery from "jquery";
window.$ = window.jQuery = jQuery;


// import logo from './assets/images/logo-universal.png';
import {Greet, ScanDir} from '../wailsjs/go/main/App';
import { main } from '../wailsjs/go/models';

let PWD:string = "/home/jptrzy";

// Setup the greet function
window.greet = function () {
    // Get name
    let name = nameElement!.value;

    // Check if the input is empty
    if (name === "") return;

    // Call App.Greet(name)
    try {
        Greet(name)
            .then((result) => {
                // Update result with data back from App.Greet()
                resultElement!.innerText = result;
            })
            .catch((err) => {
                console.error(err);
            });
    } catch (err) {
        console.error(err);
    }
};

const SUP_IMG_FORMATS: string[] = [".png", ".webp", ".jpg", ".jpeg"];

function endsWithAny(suffixes: string[], string: string) {
    return suffixes.some(function (suffix) {
        return string.endsWith(suffix);
    });
}

window.scan_dir = function(path:string, save:boolean){
	try {
		ScanDir(path)
			.then((result: main.ScanDirJSON) => {
				if (result.status == 0) {
					result.files.sort(function(a, b) {
						return a.name.localeCompare(b.name, undefined, {numeric: true, sensitivity: 'base'});
					});	

					let html = PWD == "/" ? "" : '<li class="dir">..</li>';
					result.files.forEach((file: main.File) => {
						html += `<li class="${file.dir ? "dir" : ""} 
${endsWithAny(SUP_IMG_FORMATS, file.name) ? "img":""}">${file.name}</li>`;
					});
					$("#dirs").html(html);
					
					if (save) {
						PWD = path;
					}
				}
			}).catch((err) => {
				console.error(err);
			})
	} catch (err) {
		console.error(err);
	}	    
}

window.scan_dir(PWD, true);
$(document).on('click', "li.dir", function(e) {
	let path:string = PWD + "/" + $(this).text();

	if ($(this).text() === "..") {
		path = path.slice(0, PWD.lastIndexOf("/"));
	}

	console.log($(this).text(), path, e);

	window.scan_dir(path, true);
});

/*
document.querySelector('#app')!.innerHTML = `
    <img id="logo" class="logo">
      <div class="result" id="result">Please enter your name below 👇</div>
      <div class="input-box" id="input">
        <input class="input" id="name" type="text" autocomplete="off" />
        <button class="btn" onclick="greet()">Greet</button>
      </div>
    </div>
`;
(document.getElementById('logo') as HTMLImageElement).src = logo;
*/
let nameElement = (document.getElementById("name") as HTMLInputElement);
nameElement.focus();
let resultElement = document.getElementById("result");


declare global {
    interface Window {
        greet: () => void;
        scan_dir: (path:string, save:boolean) => void;
        $: any;
        jQuery: any;
    }
}
