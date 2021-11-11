# Parodikos

Ever wanted to get rid of your old tweets? Well now you can! Parodikos will
accept your Twitter handle and a date as inputs and will delete all of your
tweets before that date.

The only thing required is to set up a `credentials.yml` file (details below).

## Installation

For now this is pretty barebones. The first step is to clone this repo and run:

    $ bundle install

Then create your own `credentials.yml` file:

    $ cp credentials.yml.sampl credentials.yml

You will have to go to [Twitter](https://developer.twitter.com/content/developer-twitter/en/portal/projects-and-apps) and obtain these for yourself.

## Usage

To perform a dry run:

    $ exe/parodikos reap --screen_name=nikosfertakis --before=2013-09-01 --dry=true

To actually delete tweets

    $ exe/parodikos reap --screen_name=nikosfertakis --before=2013-09-01 --dry=false

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/greenonion/parodikos.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
