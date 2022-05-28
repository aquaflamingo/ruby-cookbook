# Custom ERB
The [Embedded Ruby](https://rubyapi.org/o/erb) library is very useful for creating reusable template file for rendering data on forms, web pages and more. 

You can use ERB for your own custom templates as well.

## Usage
Create a template file for use, for example, `__template.erb.txt`. You will need to use the ERB syntax to enable the template to render data properly

```plaintext
# __template.erb.txt

First Name:<%= first_name %>
Last Name:<%= last_name %>
PhoneNumber:<%= phone %>
```

Next you need to create the class containing the attributes (or methods) specified in the ERB file that will be used as the data source to render.

```ruby
class Person
  attr_accessor :fname, :lname, :phone

  TEMPLATE_FILE_PATH = "__template.erb.txt"

  def initialize(fname, lname, phone)
    @fname = fname
    @lname = lname
    @phone = phone
  end

  def render
    erb_template_filepath = File.join(TEMPLATE_FILE_PATH)

    erb = ERB.new(File.read(erb_template_file_path))

    erb.result(get_binding)
  end

  # disable:rubocop
  def get_binding
    binding
  end
end
```

