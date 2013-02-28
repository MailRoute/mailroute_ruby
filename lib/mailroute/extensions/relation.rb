require 'active_support/core_ext'

class Mailroute::Relation
	delegate :inspect, :each, :count, :&, :to_ary, :all?, :to => :to_a

	attr_reader :search_options

	def initialize(klass, search_options = {})
		@klass = klass
		@search_options = search_options
	end

	def to_a
		@records ||= @klass.all(search_options)
	end

	def limit(n)
		Mailroute::Relation.new(@klass,  search_options.deep_merge(:params => { :limit => n }))
	end

	def offset(n)
		Mailroute::Relation.new(@klass,  search_options.deep_merge(:params => { :offset => n }))
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
end
