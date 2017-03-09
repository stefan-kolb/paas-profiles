# Contributing

We love contributions from everyone!

Fork, then clone the repo:

    git clone git@github.com:your-username/paas-profiles.git

Please see below how to setup your environment for development if you haven't done so already.
Make your change. Add tests for your change. Make sure the tests and code style validations pass:

    bundle exec rake

Push to your fork and submit a pull request.

## How to add a new profile

To add a new PaaS offering, add a new JSON file inside the folder [`profiles`](/profiles/).

    paas_name_without_special_characters.json

Please see the [profile specification](README.md#profile-specification) for details on the expected format.

To include a logo for your PaaS you must provide two `.png` images inside the folder [`public/img/vendor`](/public/img/vendor).

    `paas_name.png` at 80x80 pixels
    `paas_name_big.png` at 400x400 pixels

## Development

### Preparing the environment

Fork, then clone the repo:

``` bash
git clone git@github.com:your-username/paas-profiles.git
cd paas-profiles
bundle install
```

Set your local rack environment to `development` via an environment variable.

``` bash
export RACK_ENV=development
```

> __Problems with the installation of rmagick gem__
>
> **Note:** On some Ubuntu and OS X installations you might find the following
> error concerning the MagickCore package:
>
> ```
> Package MagickCore was not found in the pkg-config search path.
> (...)
> An error occurred while installing rmagick (2.15.4), and Bundler cannot continue.
> Make sure that `gem install rmagick -v '2.15.4'` succeeds before bundling.
> ```
>
> On Ubuntu:
>
> In that case you might need to manually install `libmagickwand-dev`
> and `imagemagick` libraries, and relaunch the install:
>
> ``` bash
> sudo apt-get install libmagickwand-dev imagemagick
> bundle install
> ```
>
> On OS X:
>
> Install imagemagick via macports (requires pre-installed macports) 
> ``` bash
> sudo port install ImageMagick
> ```
> Note: Homebrew installs ImageMagick 7 that causes problems while installing rmagick.
>
> On Windows:  
>
> Please see [https://github.com/rmagick/rmagick/wiki/Installing-on-Windows](https://github.com/rmagick/rmagick/wiki/Installing-on-Windows) for installation instructions.
>

### Preparing the Database

To run the tests and a local instance of the application, you will
need an instance of MongoDB running (see `./config/mongoid.yml` for connection details)
- You can install it, e.g., via [this script](https://gist.github.com/rbf/4001e6cc6d74465803f3)  
- Alternatively, run it with Docker: `docker run -d -p 27017:27017 --name mongodb mongo`

Next, you need to seed the database:

    bundle exec rake db:seed

### Locally launch the application

You can start the application with following command:

``` bash
bundle exec rackup
```

### Testing

As stated above, before sending a pull request make sure that `bundle exec rake` passes.
