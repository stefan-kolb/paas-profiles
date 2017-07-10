function Infrastructure(data) {
	var self = this;
  self.continent = ko.observable(data.continent);
  self.country = ko.observable(data.country);
  self.provider = ko.observable(data.provider);
	self.region = ko.observable(data.region);
}