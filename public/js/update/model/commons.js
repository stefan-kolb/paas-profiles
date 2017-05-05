function filterEmptyElements(array) {
	return array.filter(elem => { if (elem.value != "") return elem } );
}