// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function highlightTask(x) {
	x.style.background = '#C0C0C0';
}

function unhighlightTask(x) {
	x.style.background = '#FFFFFF';
}

function toggleComplete(id) {
	document.getElementById(id).innerHTML = "hello";
}
