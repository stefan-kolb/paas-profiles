# Paas Profiles

*Making PaaS offerings comparable - Ecosystem profiles for PaaS vendors.*

Currently 82 PaaS vendor profiles. Profiles are encoded as [JSON files](/profiles/).

For convenience, the profiles can be viewed via executing the [sinatra app](sinatra_profiles.rb).

**The current web interface can be viewed [online](http://paas-profiles.aws.af.cm/vendors).**

**Any errors? Important missing properties? Suggestions? [Contribute](#contribution)**
## Profile

The code below shows a sample profile. The profile specification is beta and the properties are subject to change.

```javascript
{
  "name": "SomePaas",
  "revision": "2013-07-02", // last profile update
  "vendor_verified": false, // profile verified by vendor
  "url": "http://someurl.com",
  "status": "production", // [beta, production, eol]
  "status_since": "2012-07-15",
  "type": "polyglot", // [language-specific, polyglot, apaas]
  "hosting": [
    "public" // [public, private]
  ],
  "pricing": "Monthly", // tbd
  "scaling": {
    "vertical": true, "horizontal": true, "auto": false
  },
  "compliance": [
    "SSAE 16 Type II", "ISAE 3402 Type II"
  ],
  "runtimes": [
    { "language": "java", "versions": [ "1.7", "1.6" ] }
  ],
  "middleware" [
    { "name": "tomcat", "versions": [ "6.0.35" ] }
  ],
  "frameworks": [
  ],
  "services": {
    "native": [
      { "name": "mongodb", type="", "versions": [ "1.8" ] } // tbd
    ],
    "addon": [
      { "name": "mongolab", url="https://mongolab.com/", desc="", type="" } // tbd
    ]
  },
  "extendable": false, // buildpack-like support
  "infrastructures": [
    { 
      "continent": "NA",
      "country": "US",
      "region": "Virginia",
      "provider": "AWS"
    }
  ]
}
```
### Name  

The official name of the PaaS offering.

### Revision

`Date` or `DateTime` of the profile's last update.
 
### Vendor Verification

This may be set to `true` if the profile was officially created or audited by the vendor.

### URL

The URL leading to the Paas' webpage.

### Status

The current status of the offering. This may be one of the following lifecycle stages:

`beta` = In private or public beta testing  
`production` = Live and generally available  
`eol` = Discontinued or integrated into another offering (End of life).  

### Status Since

`Date` of the last status transition.

### Type

Type of the PaaS. Currently allowed categories:

```
language-specific, polyglot, apaas
```

### Pricing

The pricing model of the PaaS. Values tbd

### Scaling

An object including three boolean properties for characterizing the scaling capabilities:

`vertical` = Can you scale the instance sizes, e.g. ram?  
`horizontal` = Can you scale the number of instances?  
`auto` = Is the PaaS capable of scaling any of the above properties automatically?    

### Hosting

An array that describes the different provided hosting styles of the PaaS.
Values can be `public` for a publicly hosted service and `private`for a service that can be deployed on premise, too.

### Compliance

Currently a simple array of compliance standard strings that are fulfilled by the PaaS.

### Runtimes

The runtimes an application can be written in. Defined as an array of objects.

```json
"runtimes": [
    { "language": "java", "versions": [ "1.7", "1.6" ] },
    { "language": "ruby", "versions": [ "1.9.3", "2.0.0" ] }
]
```

#### Language

This section must only include languages that are officially supported by the vendors.
Languages added via community buildpacks must not be added. Extensibility is modeled by the property *extenable*. 
In order to allow exact matching, the language keys are restricted. Currently allowed keys are:

```
apex, clojure, cobol, dotnet, erlang, go, groovy, haskell, java, lua, node, perl, php, python, ruby, scala
```

#### Versions

A string array containing the supported runtime versions.

### Middleware

An array of preconfigured middleware stacks.

```json
"middleware": [
    { "name": "tomcat", "versions": [ "6", "7" ] },
    { "name": "glassfish", "versions": [ "3.1" ] }
]
```

#### Name

Should be the official name in lowercase. Currently not restricted.

#### Versions

A string array containing the supported middleware versions.

### Frameworks

*tbd*

### Services

```json
"services": {
  "native": [
    { "name": "mongodb", type="", "versions": [ "1.8" ] } // tbd
  ],
  "addon": [
    { "name": "mongolab", url="https://mongolab.com/", desc="", type="" } // tbd
  ]
}
```

#### Native

#### Addon

##### Type

*tbd*

### Infrastructures

The infrastructures an application can be deployed to. Defined as an array of objects.

```json
"infrastructures": [
    { 
      "continent": "EU",
      "country": "IE",
      "region": "Dublin",
      "provider": "AWS"
    }
]
```

#### Continent

The continent must be encoded with the following continent codes:

```
AF = Africa, AS = Asia, EU = Europe, NA = North America, OC = Oceania, SA = South America
```

#### Country

The country codes must conform to the country codes defined in [ISO 3166-2](http://en.wikipedia.org/wiki/ISO_3166-2).

#### Region

The property region can be used to further specify the location of the datacenter. This field is freeform and may specify a region or even the city the datacenter is located in.

#### Provider

This optional field may specify the name of the external IaaS provider used by the PaaS vendor, e.g. *Amazon Web Services*.

## Authors

[Stefan Kolb](https://github.com/stefan-kolb)

## Contribution

I encourage everyone to submit corrections or additions in order to keep the profiles accurate and up-to-date.
In any case, please add evidence for the information so I can verify your changes.

Contribute either via [pull request](https://help.github.com/articles/using-pull-requests), create an [issue](https://github.com/stefan-kolb/paas-profiles/issues) or send me an [email](mailto:stefan.kolb@uni-bamberg.de).
