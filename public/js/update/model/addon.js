Addon.prototype.toJSON = function() {
  var copy = ko.toJS(this);
  return copy;
}

function Addon(data){
  var self = this;
  self.name = ko.observable(data.name);
  self.url = ko.observable(data.url);          
  self.description = data.description;
  self.type = ko.observable(data.type);
}