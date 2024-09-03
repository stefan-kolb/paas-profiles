# ⚠️ Unmaintained ⚠️

**This repository is no longer actively maintained.**  
Thank you to everyone who contributed to this project.

# [PaaS Profiles](https://paasfinder.org)

*Making Platform as a Service offerings comparable - Ecosystem profiles for portability matching.*

<br/>
A no-standards approach for application portability.

Currently over 100 PaaS vendor profiles. Profiles are encoded as [JSON files](/profiles/).

**The web interface can be viewed at [PaaSfinder.org](https://paasfinder.org)**

**Any errors? Important missing properties? Suggestions? [Contribute](#contribution).**

## Contribution

I encourage **everyone** to submit corrections or additions in order to keep the profiles accurate and up-to-date.
In any case, please add evidence for the information so I can verify your changes.

I am also interested in direct **cooperation with vendors** in order to keep the profiles at first hand and spot-on. Contact me, if you are interested to supply a [vendor verified profile](#vendor-verification).

Contribute either via [pull request](https://help.github.com/articles/using-pull-requests), create an [issue](https://github.com/stefan-kolb/paas-profiles/issues) or send me an [email](mailto:stefan.kolb@uni-bamberg.de).
We love contributions from everyone! See our [contribution guidelines](CONTRIBUTING.md) for details.

## Profile Specification

- [General Properties](#name)
- [Pricing](#pricing)
- [Quality of Service](#quality-of-service)
- [Hosting](#hosting)
- [Scaling](#scaling)
- [Runtimes](#runtimes)
- [Middleware](#middleware)
- [Frameworks](#frameworks)
- [Services](#services)
- [Infrastructures](#infrastructures)

The code below shows a sample profile.

```json
{
  "name": "SomePaas",
  "revision": "2014-04-24",
  "vendor_verified": "2013-07-02",
  "url": "http://someurl.com",
  "status": "production",
  "status_since": "2012-07-15",
  "type": "Generic",
  "platform": "Cloud Foundry",
  "hosting": {
    "public": true, "virtual_private": true, "private": false
  },
  "pricings": [
		{ "model": "fixed", "period": "monthly" }
  ],
  "qos": {
        "uptime": 99.8,
        "compliance": [
          "SSAE 16 Type II", "ISAE 3402 Type II"
        ]
  },
  "scaling": {
    "vertical": true, "horizontal": true, "auto": false
  },
  "runtimes": [
    { "language": "java", "versions": [ "1.7", "1.6" ] }
  ],
  "middlewares": [
    { "name": "tomcat", "runtime": "java", "versions": [ "6.0.35" ] }
  ],
  "frameworks": [
	{ "name": "rails", "runtime": "ruby", "versions": [ "4.0.0" ] },
	{ "name": "django", "runtime": "python", "versions": [ "1.5.1" ] }
  ],
  "services": {
    "native": [
      { "name": "mongodb", "description": "", "type": "datastore", "versions": [ "1.8" ] }
    ],
    "addon": [
      { "name": "mongolab", "url": "https://mongolab.com/", "description": "", "type": "datastore" }
    ]
  },
  "extensible": false,
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

[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) `Date` or `DateTime` of the profile's last update.
 
### Vendor Verification

This may be set to the [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) `Date` when the profile was officially created or audited by the vendor.

### URL

The URL leading to the PaaS' webpage.

### Status

The current status of the offering. This may be one of the following lifecycle stages:

`alpha` = Work in progress or early test version  
`beta` = In private or public beta testing  
`production` = Live and generally available  
`eol` = Discontinued or integrated into another offering (End of life)

### Status Since

[ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) `Date` of the last status transition.

### Type

Positioning of the PaaS in between IaaS and SaaS. Currently allowed categories:

```
SaaS-centric, Generic, IaaS-centric
```

Please see [this paper](https://www.uni-bamberg.de/fileadmin/uni/fakultaeten/wiai_lehrstuehle/praktische_informatik/Dateien/Publikationen/sose14-towards-application-portability-in-paas.pdf) for more information about the suggested service types.

### Platform

If you are a provider using a core platform like Cloud Foundry or OpenShift, please specify this within the `platform` attribute via the platform's name from the linked profile.
Customers are then able to find your offering when looking for providers of the core platform.

### Pricing

An array of all available billing options.

#### Model

The pricing model of the PaaS. Currently allowed values:
```
free, fixed, metered, hybrid
```
#### Period

The billing period. Currently allowed values:
```
daily, monthly, annually
```

Can be omitted if the pricing model is ```free```.

### Quality of Service

#### Uptime

The guaranteed monthly uptime by the provider.

#### Compliance

Currently a simple string array of compliance standards that are fulfilled by the PaaS.

### Hosting

An object that describes the different provided hosting styles of the PaaS.
Values can be `public` for a shared (multi-tenant) publicly hosted service, `virtual_private` for a virtual private cloud deployment (single-tenant), and `private` for a service that can be deployed on premises.

### Scaling

An object including three boolean properties for characterizing the scaling capabilities:

`vertical` = Can you scale the instance sizes, e.g. memory?
`horizontal` = Can you scale the number of instances?
`auto` = Is the PaaS capable of scaling any of the above properties automatically?

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
Languages added via community buildpacks must not be added. Extensibility is modeled by the property *extensible*.
In order to allow exact matching, the language keys are restricted. Currently allowed keys are:

```
apex, clojure, cobol, dotnet, erlang, go, groovy, haskell, java, lua, node, perl, php, python, ruby, scala
```

*Note: Due to common parlance the Node framework is listed as language being the de facto standard for server-side scripting with JavaScript.*

#### Versions

A string array containing the supported runtime versions. Wildcards `*` may be used for branches or even marking all major versions as supported (e.g. `*.*`).

### Middleware

An array of *preinstalled or fully supported* middleware stacks.

```json
"middlewares": [
    { "name": "tomcat", "runtime": "java", "versions": [ "6", "7" ] },
    { "name": "nginx", "versions": [ "1.6" ] }
]
```

#### Name

Should be the official name in lowercase. Currently not restricted.

#### Runtime

(Optional) The associated runtime of the middleware product.

#### Versions

A string array containing the supported middleware versions.

### Frameworks

An array of *officially and fully supported* frameworks.

```json
"frameworks": [
    { "name": "rails", "runtime": "ruby", "versions": [ "4.0.0" ] },
    { "name": "django", "runtime": "python", "versions": [ "1.5.1" ] }
]
```

#### Name

Should be the official name in lowercase. Currently not restricted.

#### Runtime

The associated runtime of the framework. Must be defined under [runtimes](#runtimes).

#### Versions

A string array containing the supported framework versions.

### Services

```json
"services": {
  "native": [
    { "name": "mongodb", "type": "datastore", "description": "", "versions": [ "1.8" ] }
  ],
  "addon": [
    { "name": "mongolab", "url": "https://mongolab.com/", "description": "", "type": "datastore" }
  ]
}
```

#### Native

Native services or core services are *provided and hosted by the PaaS vendor* as integral part of the offering. Most often this will be performance critical core services like data stores.

#### Add-on

Add-on services are *provided by external vendors* and may or may not be hosted in the same infrastructure as the PaaS. However, we only categorize services as add-ons if they can be provisioned directly from the PaaS and will be billed as additional part of the platform fee.

#### Type

A category the service does fit in. Currently allowed keys are:
*tbd* Maybe make it an array of types. 

```
datastore, search, worker, analytics, payment, media, messaging, other, devops
```

### Extensible

This boolean describes if the PaaS can be extended by the customer to use additional runtime languages other than described by the profile and officially supported by the provider.
Typical technological concepts to realize this are Heroku's buildpacks and OpenShift cartridges.

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

The country codes must conform to the two-letter codes defined in [ISO 3166-1](http://en.wikipedia.org/wiki/ISO_3166-1).

#### Region

The property region can be used to further specify the location of the datacenter. This field is free-form and may specify a region or even better the city the datacenter is located in.

#### Provider

This optional field may specify the name of the external IaaS provider used by the PaaS vendor, e.g. *Amazon Web Services*.
