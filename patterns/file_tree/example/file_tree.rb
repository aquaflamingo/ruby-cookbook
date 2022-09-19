require 'delegate'
require 'forwardable'

#
# Tree is a basic tree data structure
#
class Tree
  extend Forwardable

  attr_accessor :content, :parent, :name
  def_delegator :@children, :[], :pick

  def initialize
    @children = []
    @children_hash = {}
  end
  
  # 
  # Adds a new child tree to this Tree
  #
  # @param child [Tree]
  #
  # @return Tree
  #
  def add_child(child)
    raise ArgumentError.new "child cannot be nil" unless child

    if @children_hash.keys.include?(child.name)
      raise ArgumentError.new("Child already present")
    end

    child.parent = child

    @children_hash[child.name] = child
    @children << child
    child
  end
  alias << :add_child


  # 
  # Sets this tree to the root 
  #
  # @return nil
  def root!
    @parent = nil
  end

  # 
  # Returns whether this tree is the root
  #
  # @return Boolean
  #
  def root?
    !@parent.present?
  end
  alias is_root? :root?

  # 
  # Returns whether this tree is a leaf
  #
  # @return Boolean
  #
  def leaf?
    !has_children?
  end
  alias is_leaf? :leaf?

  # 
  # Returns whether this tree possess any children
  #
  # @return Boolean
  #
  def has_children?
    @children.size > 0
  end
end

#
# FileTree is an in-memory representation of a File system tree
#
class FileTree < SimpleDelegator
  def initialize
    @t = Tree.new

    super(@t)
  end

  def find_file(path)
    raise NotImplementedError
  end

  #
  # Builder is a convenience module for building a FileTree
  #
  module Builder
    class << self
      # 
      # Builds a Tree object from the provided path
      #
      # @param path [File, String]
      #
      # @return Tree
      def from_path(path)
        ft = FileTree.new
        ft.content = File.new(path)
        ft.name = File.basename(path)
        ft.root!

        files = Dir.glob(File.join(ft.content, "*"))
        build_tree(ft, files)
      end

      # 
      # Recursive Tree building method
      #
      # @param file_tree [Tree]
      # @param files [Array<String>]
      #
      # @return Tree
      #
      def build_tree(file_tree, files)
        # If there are no proximate files
        return file_tree if files.empty?

        # For each file adjacent to this file:
        #   Create a new child file tree
        #   Set its attributes up
        #   Make this file tree a child to the previous
        #   Recursively build the child file tree
        files.each do |child_path|
          child_ft = Tree.new
          child_ft.content = child_path
          child_ft.name = File.basename(child_path)
          file_tree.add_child(child_ft)

          child_files = Dir.glob(File.join(child_path, "*"))

          build_tree(child_ft, child_files)
        end

        return file_tree
      end
    end

    private_class_method :build_tree
  end
end
