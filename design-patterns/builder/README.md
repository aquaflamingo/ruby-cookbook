# Builder Design Pattern

The Builder design pattern allows you to reduce constructor size and create a more usable API for creating complex objects

## Pattern
```ruby
class Widget
  attr_accessor :serial_no :model, :created_at

  class Builder
    def self.build
      builder = new

      yield(builder)

      builder.result
    end

    def initialize
      @widget = Widget.new
    end

    def serial_no(no)
      @widget.serial_no = no
    end

    def model(m)
      @widget.model = m
    end

    def created_at(d)
      @widget.created_at = d
    end

    def result
      @widget
    end
  end
end
```
