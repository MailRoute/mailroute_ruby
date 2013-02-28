module LazyHash
  def []=(key, value)
    if value.respond_to? :call
      def value.method_missing(name, *args, &block)
        call.send(name, *args, &block)
      end
    end

    super(key, value)
  end

  def [](key)
    evaluate(super(key))
  end

  private

  def evaluate(v)
    if v.respond_to? :call
      v.call
    else
      v
    end
  end
end