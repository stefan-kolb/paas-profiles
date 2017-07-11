function fillPricingTable(pricings){
  var tableBody = document.getElementById('pricings');
  for (var i = 0; i < pricings.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
      
    td1.className = 'class="span1"';
    td2.className = 'class="span3"';
    td3.className = 'class="span3"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(pricings[i].model);
    var text3 = document.createTextNode(pricings[i].period);

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)

    tableBody.appendChild(tr);
  }
}

function fillRuntimeTable(runtimes){
  var tableBody = document.getElementById('runtimes');
  for (var i = 0; i < runtimes.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
      
    td1.className = 'class="span1"';
    td2.className = 'class="span3"';
    td3.className = 'class="span3"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(runtimes[i].language);
    var text3 = document.createTextNode(runtimes[i].versions.toString().split(',').join(', '));

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)

    tableBody.appendChild(tr);
  }
}

function fillMiddlewareTable(middlewares){
  var tableBody = document.getElementById('middlewares');
  for (var i = 0; i < middlewares.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    
    td1.className = 'class="span1"';
    td2.className = 'class="span2"';
    td3.className = 'class="span2"';
    td4.className = 'class="span2"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(middlewares[i].name);
    var text3 = document.createTextNode(middlewares[i].runtime);
    var text4 = document.createTextNode(middlewares[i].versions.toString().split(',').join(', '));

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);
    td4.appendChild(text4);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)
    tr.appendChild(td4)

    tableBody.appendChild(tr);
  }
}

function fillFrameworkTable(frameworks){
  var tableBody = document.getElementById('frameworks');
  for (var i = 0; i < frameworks.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    
    td1.className = 'class="span1"';
    td2.className = 'class="span2"';
    td3.className = 'class="span2"';
    td4.className = 'class="span2"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(frameworks[i].name);
    var text3 = document.createTextNode(frameworks[i].runtime);
    var text4 = document.createTextNode(frameworks[i].versions.toString().split(',').join(', '));

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);
    td4.appendChild(text4);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)
    tr.appendChild(td4)

    tableBody.appendChild(tr);
  }
}

function fillInfrastructureTable(infrastructures){
  var tableBody = document.getElementById('infrastructures');
  for (var i = 0; i < infrastructures.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    var td5 = document.createElement('td');
    
    td1.className = 'class="span1"';
    td2.className = 'class="span1"';
    td3.className = 'class="span1"';
    td4.className = 'class="span2"';
    td5.className = 'class="span2"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(infrastructures[i].continent);
    var text3 = document.createTextNode(infrastructures[i].country);
    var text4 = document.createTextNode(infrastructures[i].provider);
    var text5 = document.createTextNode(infrastructures[i].region);

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);
    td4.appendChild(text4);
    td5.appendChild(text5);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)
    tr.appendChild(td4)
    tr.appendChild(td5)

    tableBody.appendChild(tr);
  }
}

function fillNativeTable(natives){
  var tableBody = document.getElementById('natives');
  for (var i = 0; i < natives.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    
    td1.className = 'class="span1"';
    td2.className = 'class="span2"';
    td3.className = 'class="span2"';
    td4.className = 'class="span2"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(natives[i].name);
    var text3 = document.createTextNode(natives[i].type);
    var text4 = document.createTextNode(natives[i].versions.toString().split(',').join(', '));

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);
    td4.appendChild(text4);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)
    tr.appendChild(td4)

    tableBody.appendChild(tr);
  }
}

function fillAddonTable(addons){
  var tableBody = document.getElementById('addons');
  for (var i = 0; i < addons.length; i++){
    var tr = document.createElement('tr');   

    var td1 = document.createElement('td');
    var td2 = document.createElement('td');
    var td3 = document.createElement('td');
    var td4 = document.createElement('td');
    
    td1.className = 'class="span1"';
    td2.className = 'class="span2"';
    td3.className = 'class="span2"';
    td4.className = 'class="span2"';

    var text1 = document.createTextNode(i+1);
    var text2 = document.createTextNode(addons[i].name);
    var text3 = document.createTextNode(addons[i].type);
    var text4 = document.createTextNode(addons[i].url);

    td1.appendChild(text1);
    td2.appendChild(text2);
    td3.appendChild(text3);
    td4.appendChild(text4);

    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3)
    tr.appendChild(td4)

    tableBody.appendChild(tr);
  }
}