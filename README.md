# git-chlog

A git custom command `git chlog` to print changelog with a list of merged pull-requests grouped by tags from any git repository.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'git-chlog'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git-chlog

## Usage

```sh
git chlog > CHANGELOG.md
```

### Prepare new release
To prepare new release, you want to update changelog before creating new git tag. You can specify to-be-released tag name, it'll group new merged pull-requests under this tag name:

```sh
git chlog --prepare-release=v2.29.0 > CHANGELOG.md
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/git-chlog. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Git::Chlog project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/git-chlog/blob/master/CODE_OF_CONDUCT.md).
