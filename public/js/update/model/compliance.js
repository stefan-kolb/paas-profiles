Compliance.prototype.toJSON = function() {
  var copy = ko.toJS(this);
  return copy.value;
}

function Compliance(data){
  var self = this;
  self.value = ko.observable(data);
}