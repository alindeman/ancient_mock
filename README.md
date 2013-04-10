# AncientMock

A simple mock object library that I built on stage at [Ancient City
Ruby](http://ancientcityruby.com).

**Do not use in production!** It was an academic exercise meant to teach
the basics of building a mock object library.

* Video from the talk (not yet posted)
* [Slides from the talk](https://docs.google.com/presentation/d/1laaQYHFyzcTJzlB9qMmEHyoHIB-S93p9B4L8SbbhoTw/edit#slide=id.p)

## Installation

```ruby
# Gemfile
gem 'ancient_mock'
```

## Usage

```ruby
warehouse = Object.new

# Stub
allow(warhouse).to receive(:full?).and_return(true)
warehouse.full? # => true

# Mock
item_id = 1234
expect(warehouse).to receive(:remove).with(item_id)
# warehouse.remove(1234) must be called
```

## Tests

```ruby
bundle exec rake
```
