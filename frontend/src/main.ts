import './style.css';
import './app.css';

// import logo from './assets/images/logo-universal.png';
import {Greet, ScanDir} from '../wailsjs/go/main/App';
// import { main } from '../wailsjs/go/models';

let PWD:string = "\home\jp3";

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

window.scan_dir = function(path:string, save:boolean){
	try {
		ScanDir(path)
			.then((result) => {

				console.log(PWD, save);
				console.log(result);

			}).catch((err) => {
				console.error(err);
			})
	} catch (err) {
		console.error(err);
	}	    
}

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
    }
}
