Quality.prototype.toJSON = function() {
  var copy = ko.toJS(this);
  copy.compliance = filterEmptyElements(copy.compliance);
  return copy; 
}

function Quality(data) {
  // default values
  if (data == null) {
    data = {uptime: "", compliance: []};
  }
  if (data.compliance == null) {
    data.compliance = [];
  }

  var self = this;
  self.uptime = ko.observable(data.uptime);
  self.compliance = ko.observableArray( 
    $.map(data.compliance, function(elem) { return new Compliance(elem) }) 
  ); 

  self.addCompliance = function () {
    self.compliance.push(new Compliance(""));
  };
    
  self.removeCompliance = function(compliance){
    if (confirm('Do you want to delete this compliance?')) {
      self.compliance.remove(compliance);
    } 
  }
}