VendorModel.prototype.toJSON = function() {
  var copy = ko.toJS(this);
  
  if(copy.platform == ""){
    delete copy.platform;
  }

  if(copy.quality.uptime == "" && copy.quality.compliance.length == 0){
    delete copy.quality;
  }
  
  return copy;
} 

function VendorModel(vendor) {
  var self = this;
  self.name = vendor.name;
  self.revision = new Date().toJSON().slice(0,10);
  self.vendor_verified = vendor.vendor_verified;
  self.url = vendor.url;
  self.status = vendor.status;
  self.status_since = vendor.status_since;
  self.type = vendor.type;
  self.platform = vendor.platform;
  self.hosting = vendor.hosting;
  self.pricings = ko.observableArray(vendor.pricings || []);         
  self.quality = new Quality(vendor.quality);
  self.scaling = vendor.scaling;

  self.runtimes = ko.observableArray(
    $.map(vendor.runtimes, function(runtime) { return new Runtime(runtime) })
  );

  self.middlewares = ko.observableArray(
    $.map(vendor.middlewares, function(middleware) { return new Middleware(middleware) })
  );

  self.frameworks = ko.observableArray(
    $.map(vendor.frameworks, function(framework) { return new Framework(framework) })
  );

  self.services = new Service(vendor.service);
  self.extensible = vendor.extensible;
  self.infrastructures = ko.observableArray(vendor.infrastructures || []);
   
  // Operations
  self.addPricing = function() { 
  self.pricings.push({model: "", period:""});
    $('.selectpicker').selectpicker(); 
  };
       
  self.removePricing = function(pricing) { 
    if (confirm('Do you want to delete this pricing?')) {
      self.pricings.remove(pricing);
    }
  };

  self.addRuntime = function() { 
    self.runtimes.push(new Runtime({language: "", versions: []}));
    $('.selectpicker').selectpicker(); 
  };
       
  self.removeRuntime = function(runtime) { 
    if (confirm('Do you want to delete this runtime?')) {
      self.runtimes.remove(runtime) 
    }
  };

  self.addMiddleware = function() { 
    self.middlewares.push(new Middleware({name: "", runtime: "", versions: []})); 
    $('.selectpicker').selectpicker();
  };
       
  self.removeMiddleware = function(middleware) { 
    if (confirm('Do you want to delete this middleware?')) {
      self.middlewares.remove(middleware) 
    }
  };

  self.addFramework = function() { 
    self.frameworks.push(new Framework({name: "", runtime: "", versions: []}));
    $('.selectpicker').selectpicker(); 
  };
       
  self.removeFramework = function(framework) { 
    if (confirm('Do you want to delete this framework?')) {
      self.frameworks.remove(framework) 
    }
  };

  self.addInfrastructure = function() { 
    self.infrastructures.push(new Infrastructure({continent: "", country: "", provider: "", region: ""}));
    $('.selectpicker').selectpicker();
  };
       
  self.removeInfrastructure = function(infrastructure) { 
    if (confirm('Do you want to delete this infrastructure?')) {
      self.infrastructures.remove(infrastructure) 
    }
  }; 

};