# Paas Profiles

*Making PaaS offerings comparable - Ecosystem profiles for PaaS vendors.*

Currently 65 PaaS vendor profiles. Profiles are encoded as [JSON files](/profiles/).

For convenience, the profiles can be viewed via executing the [sinatra app](paas_profiles.rb) or online at *tbd*.

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
    { "language": "java", "version": "1.7" } // [java, php, python, ruby, dotnet, node, go, ...]
  ],
  "middleware" [
    { "name": "tomcat", "version": "6.0.35" }
  ],
  "frameworks": [
  ],
  "services": {
    "native": [
      { "name": "mongodb", "version": "1.8" } // tbd
    ],
    "addon": [
      { "name": "mongolab" } // tbd
    ]
  },
  "extendable": false, // buildpack-like support
  "infrastructures": [
    { 
      "continent": "NA", // [NA, SA, EU, AS, AF, OC]
      "country": "US", // ISO 3166-1 alpha-2 codes
      "region": "Virginia", // region or city
      "provider": "AWS" // optional external IaaS provider
    }
  ]
}
```

## Authors

[Stefan Kolb](https://github.com/stefan-kolb)

## Contribution

I encourage everyone to submit corrections or additions in order to keep the profiles accurate and up-to-date.
In any case, please add evidence for the information so I can verify your changes.

Contribute either via [pull request](https://help.github.com/articles/using-pull-requests), create an [issue](https://github.com/stefan-kolb/paas-profiles/issues) or send me an [email](mailto:stefan.kolb@uni-bamberg.de).
