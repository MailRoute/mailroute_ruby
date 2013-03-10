RSpec::Matchers.define :all_be do |expected_class|
  match do |actual_array|
    actual_array.all? { |x| x.is_a? expected_class }
  end
end