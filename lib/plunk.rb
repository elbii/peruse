require 'elasticsearch'

require 'plunk/utils'
require 'plunk/parser'
require 'plunk/transformer'
require 'plunk/result_set'

module Plunk
  class << self
    attr_accessor :elasticsearch_options, :elasticsearch_client,
      :parser, :transformer
  end

  def self.configure(&block)
    class_eval(&block)
    initialize_elasticsearch
    initialize_parser
    initialize_transformer
  end

  def self.initialize_elasticsearch
    self.elasticsearch_client ||= Elasticsearch::Client.new elasticsearch_options
  end

  def self.initialize_parser
    self.parser ||= Parser.new
  end

  def self.initialize_transformer
    self.transformer ||= Transformer.new
  end

  def self.search(query_string)
    parsed = parser.parse query_string
    result_set = transformer.apply parsed
    result_set.eval
  end
end
