class MetaInformation
  attr_reader :associations

  def initialize(klass)
    @associations = {}
    @klass = klass
  end

  def add_has_one(model, options)
    @associations[model] = HasOne.new(@klass, model, options)
  end

  def add_has_many(model, options)
    @associations[model] = HasMany.new(@klass, model, options)
  end

  def add_has_admins(options)
    add_has_many(:admins, options)
  end
end