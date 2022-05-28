# Injectable
The injectable patterns enables you to add an arbitrary private method for a given class that `includes` the `Injectable` module.

This can be helpful when attempting to follow the Law of Demeter, and acquiring configuration values from other classes

## Pattern
```ruby
module Injectable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    # Dynamically defines a private method in the included class
    def inject(name, source)
      define_method(name.to_sym) { source.call }
      private name.to_sym
    end
  end
end
```

## Usage
```ruby
class MyClass
  include Injectable
  inject :config_value, -> { OtherClass.config_value }

  # Behind the scenes
  # The module has defined a private method called config_value like so:
  #
  # private
  #
  # def config_value
  #  OtherClass.config_value
  # end
end
```
