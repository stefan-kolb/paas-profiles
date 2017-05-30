Version.prototype.toJSON = function() {
	var copy = ko.toJS(this);
	return copy.value.replace(/,/g, ".");
}

function Version(data){
	var self = this;
	self.value = ko.observable(data);
}