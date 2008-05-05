module Arel
  class Table < Relation
    include Recursion::BaseCase

    cattr_accessor :engine
    attr_reader :name, :engine
    
    hash_on :name
    
    def initialize(name, engine = Table.engine)
      @name, @engine = name.to_s, engine
    end

    def attributes
      @attributes ||= columns.collect do |column|
        Attribute.new(self, column.name.to_sym)
      end
    end

    def column_for(attribute)
      self[attribute] and columns.detect { |c| c.name == attribute.name.to_s }
    end
    
    def ==(other)
      self.class == other.class and
      name       == other.name
    end
    
    def columns
      @columns ||= engine.columns(name, "#{name} Columns")
    end
    
    def reset
      @attributes = @columns = nil
    end
  end
end