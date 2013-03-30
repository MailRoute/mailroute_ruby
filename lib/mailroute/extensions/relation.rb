require 'active_support/core_ext'

class Mailroute::Relation
  delegate :inspect, :each, :count, :&, :to_ary, :all?, :empty?, :to => :to_a
  include Enumerable

  attr_reader :search_options

  def initialize(klass, search_options = {})
    @klass = klass
    @search_options = search_options
  end

  def to_a
    @records ||= @klass.all(search_options)
  end

  def limit(n)
    new_relation(:params => { :limit => n })
  end

  def offset(n)
    new_relation(:params => { :offset => n })
  end

  def filter(options)
    new_relation(:params => options)
  end

  def order_by(attribute)
    new_relation(:params => { :order_by => attribute })
  end

  def search(term)
    new_relation(:params => { :q => term })
  end

  def ==(other)
    case other
    when Relation
      search_options == other.search_options
    when Array
      to_a == other
    else
      false
    end
  end

  def total_count
    meta = to_a.instance_variable_get(:@_meta)
    meta && meta['total_count']
  end

  private

  def new_relation(options_update)
    Mailroute::Relation.new(@klass, search_options.deep_merge(options_update))
  end
end
