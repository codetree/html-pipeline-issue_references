# HTML::Pipeline::IssueReferences

An HTML::Pipeline filter for auto-linking GitHub issue references.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'html-pipeline-issue_references'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install html-pipeline-issue_references

## Usage

Suppose you have some text that contains references to GitHub issues, like this:

```
Fixes rails/rails#123
```

This filter will automatically transform the GitHub-style issue references into
a bonafide hyperlink to the actual issue. For example, this code:

```ruby
require "html/pipeline"
require "html/pipeline/issue_references"

pipeline = HTML::Pipeline.new [
  HTML::Pipeline::IssueReferenceFilter
]

result = pipeline.call("Fixes rails/rails#123", {
  base_url: "https://github.com",
  repository: "foo/bar"
})

puts result[:output].to_html
```

will output this:

```
Fixes <a href='https://github.com/rails/rails/issues/123' class='issue-reference'>rails/rails#123</a>
```

## Development
After checking out the repo, run `bundle install` to install dependencies.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version:
1. Update the version number <ver> in `lib/html/pipeline/issue_references/version.rb`
2. Run `gem git tag -a <ver> -m 'some msg'`
3. Run `gem push --tags`

Pushihg the git commits and tags will force CI to automatically push to [RubyGems.org](https://rubygems.org).

## Testing
Before beginning testing, be sure to run `bundle install && npm install`
Ruby unit tests can be run with `bundle exec rake test`.

## Contributing

Read the [Contributing Guidelines](CONTRIBUTING.md) and open a Pull Request!
