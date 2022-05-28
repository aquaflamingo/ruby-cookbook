class Person
  attr_accessor :fname, :lname, :phone

  TEMPLATE_FILE_PATH = "__template.erb.txt"

  def initialize(fname, lname, phone)
    @fname = fname
    @lname = lname
    @phone = phone
  end

  def render
    erb_template_file_path = File.join(TEMPLATE_FILE_PATH)

    erb = ERB.new(File.read(erb_template_file_path))

    erb.result(get_binding)
  end

  # disable:rubocop
  def get_binding
    binding
  end
end
