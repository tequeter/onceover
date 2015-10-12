require 'controlrepo/class'
require 'controlrepo/node'
require 'controlrepo/group'
require 'controlrepo/test'

class Controlrepo
  class TestConfig
    require 'yaml'

    attr_accessor :classes
    attr_accessor :nodes
    attr_accessor :groups
    attr_accessor :tests

    def initialize(file)
      begin
        config = YAML.load(File.read(file))
      rescue YAML::ParserError
        raise "Could not parse the YAML file, check that it is valid YAML and that the encoding is correct"
      end

      @classes =[]
      @nodes =[]
      @groups =[]
      @tests = []
      
      config['classes'].each { |clarse| @classes << Controlrepo::Class.new(clarse) }
      config['nodes'].each { |node| @nodes << Controlrepo::Node.new(node) }
      config['groups'].each { |name, members| @groups << Controlrepo::Group.new(name, members) }

      # Add the 'all_classes' and 'all_nodes' default groups
      @groups << Controlrepo::Group.new('all_nodes',@nodes)
      @groups << Controlrepo::Group.new('all_classes',@classes)

      # TODO: Consider renaming test_matrix
      config['test_matrix'].each do |machines, roles|
        @tests << Controlrepo::Test.new(machines,roles)
      end
    end
  end
end