Service.prototype.toJSON = function() {
  var copy = ko.toJS(this);
  return copy;
} 

function Service(data){
  // default values
  if (data == null){
    data = {natives: [], addons: []};
  } 
  if (data.natives == null) {
    data.natives = [];
  }
  if (data.addons == null) {
    data.addons = [];
  }

  var self = this;
  self.native = ko.observableArray( 
    $.map(data.natives, function(native) { return new Native(native) })
  );
  self.addon = ko.observableArray( 
    $.map(data.addons, function(addon) { return new Addon(addon) })
  );

  self.addNativeService = function(){
    self.native.push(new Native( {name:"", type: "", versions: []} ));
    $('.selectpicker').selectpicker();
  }

  self.removeNativeService = function(native){
    if (confirm('Do you want to delete this native service?')) {
      self.native.remove(native);
    }
  }

  self.addAddonService = function(){
    self.addon.push(new Addon( {name:"", type: "", url:""} ));
    $('.selectpicker').selectpicker();
  }

  self.removeAddonService = function(addon){
    if (confirm('Do you want to delete this addon service?')) {
      self.addon.remove(addon);
    }
  }
}