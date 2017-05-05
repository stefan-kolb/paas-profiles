Framework.prototype.toJSON = function() {
	var copy = ko.toJS(this);
	copy.versions = filterEmptyElements(copy.versions);
	return copy;
}

function Framework(data) {
	// default values
	if (data == null) {
		data = { name: "",  runtime: "", versions: [] };
	}
	if (data.versions == null) {
  	data.versions = [];
  }

	var self = this;
	self.name = ko.observable(data.name);
	self.runtime = ko.observable(data.runtime);
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