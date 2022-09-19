# FileTree
The file tree patterns enables you to model files within a file system using recursive globbing.

## Pattern
```ruby
require_relative 'tree'
require 'delegator'
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
```

## Usage
```ruby
class FileManager
  def initialize(root)
   @ft = FileTree::Builder.from_path(root)
  end
end

FileManager.new("$HOME/KnowledgeBase")
```
