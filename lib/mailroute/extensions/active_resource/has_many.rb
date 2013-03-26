class HasMany < Struct.new(:klass, :model, :options)
  # TODO: caching
  def inverse
    ActiveSupport::Inflector.underscore(klass.to_s.split('::').last)
  end

  def foreign_class
    options[:class] || Mailroute.const_get(ActiveSupport::Inflector.classify(model))
  end

  def pk
    options[:pk]
  end
end