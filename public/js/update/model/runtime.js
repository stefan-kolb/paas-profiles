Runtime.prototype.toJSON = function() {
	var copy = ko.toJS(this);
	copy.versions = filterEmptyElements(copy.versions);
	return copy;
}

function Runtime(data) {
	// default values
	if (data == null) {
		data = { language: "", versions: [] };
	}
	if (data.versions == null ) {
  	data.versions = [];
  }

	var self = this;
	self.language = ko.observable(data.language);
	self.versions = ko.observableArray( 
		$.map(data.versions, function(entry) { return new Version(entry) })
 	);   

	self.addVersion = function () {
		self.versions.push(new Version(""));
	};
    
	self.removeVersion = function(version){
		self.versions.remove(version);
	}
}