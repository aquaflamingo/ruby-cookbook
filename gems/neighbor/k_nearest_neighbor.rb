# frozen_string_literal: true

##
# A Rails concern that adds K-Nearest Neighbors (KNN) functionality to ActiveRecord models
# using SQLite's vector similarity search capabilities through the neighbor gem.
#
# This concern requires:
# - An `embedding` column in your model's table that stores vector data
# - SQLite installation with vector similarity search support
# - The `neighbor` gem properly installed and configured
#
# @example Adding KNN search to a Document model
#   class Document < ApplicationRecord
#     include KNearestNeighbors
#   end
#
#   # Find similar documents
#   document = Document.first
#   similar_docs = document.k_nearest_neighbors(k: 3)
#
# @example Using class method directly with a vector
#   embedding_vector = [0.1, 0.2, 0.3]
#   similar_docs = Document.k_nearest_neighbors(embedding_vector, k: 5)
#
module KNearestNeighbors
  extend ActiveSupport::Concern

  class_methods do
    ##
    # Finds k-nearest neighbors for a given embedding vector using SQLite's vector similarity search.
    #
    # @param embedding_vector [Array<Float>, String] The reference vector to find neighbors for.
    #   Can be an array of floats or a string representation of the vector.
    # @param k [Integer] The number of nearest neighbors to return. Defaults to 5.
    # @param filter_ids [Array<Integer>, nil] Optional array of record IDs to filter the search to.
    #   If provided, only records with these IDs will be considered as potential neighbors.
    #
    # @return [ActiveRecord::Relation] A relation containing the k-nearest neighbors,
    #   ordered by distance (closest first).
    #
    # @example Find 3 nearest neighbors for a vector
    #   embedding = [0.1, 0.2, 0.3]
    #   Document.k_nearest_neighbors(embedding, k: 3)
    #
    # @example Find neighbors among specific records
    #   Document.k_nearest_neighbors(embedding, k: 5, filter_ids: [1, 2, 3])
    #
    def k_nearest_neighbors(embedding_vector, k: 5, filter_ids: nil)
      scope = where("embedding MATCH ?", embedding_vector.to_s).where(k: k)
      scope = scope.where(id: filter_ids) if filter_ids.present?
      scope.order(:distance)
    end
  end

  ##
  # Finds k-nearest neighbors for the current record based on its embedding.
  #
  # @param k [Integer] The number of nearest neighbors to return. Defaults to 5.
  # @param filter_ids [Array<Integer>, nil] Optional array of record IDs to filter the search to.
  #   If provided, only records with these IDs will be considered as potential neighbors.
  #   The current record's ID will be automatically excluded from this list.
  #
  # @return [ActiveRecord::Relation] A relation containing the k-nearest neighbors,
  #   ordered by distance (closest first). Returns an empty array if the record has no embedding.
  #
  # @example Find 5 nearest neighbors for a document
  #   document = Document.first
  #   similar_docs = document.k_nearest_neighbors
  #
  # @example Find neighbors among specific records
  #   document.k_nearest_neighbors(k: 3, filter_ids: [1, 2, 3])
  #
  def k_nearest_neighbors(k: 5, filter_ids: nil)
    return [] if embedding.blank?
    
    # Exclude self from results
    ids_to_filter = Array(filter_ids)
    ids_to_filter = ids_to_filter.reject { |id| id == self.id }
    self.class.k_nearest_neighbors(embedding, k: k, filter_ids: ids_to_filter)
  end
end
