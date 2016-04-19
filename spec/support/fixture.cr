class Fixture
  def self.[](name)
    fixtures[name]
  end

  def self.[]?(name)
    fixtures[name]?
  end

  def self.[]=(name, value)
    fixtures[name] = value
  end

  def self.fixtures
    @@fixtures ||= {} of String => String
  end

  def initialize(file, ext = :wsdl)
    @file = file
    @ext = ext
  end

  @file : Symbol
  @ext : Symbol
  property :file, :ext

  def filename
    "#{file}.#{ext}"
  end

  def path
    File.expand_path("spec/fixtures/#{filename}")
  end

  def read
    Fixture[filename] ||= File.read(path)
  end
end

def fixture(*args)
  Fixture.new(*args)
end
