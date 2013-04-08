class Object
  alias_method :public_send, :send
end if RUBY_VERSION =~ /^1\.8/