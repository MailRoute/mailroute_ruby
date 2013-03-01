class Lazy < BasicObject
  def initialize(&block)
    @block = block
  end

  def method_missing(name, *args, &block)
    eval.send(name, *args, &block)
  end

  def ==(other)
    eval == other
  end

  def !=(other)
    eval != other
  end

  def eval
    @block.call
  end
end

def Lazy(&block)
  Lazy.new(&block)
end
