require 'spec_helper'

describe Mailroute::DeepClassVariableGet do
  before {
    class A
      @x = :a
      @w = :a
    end

    class B < A
      include Mailroute::DeepClassVariableGet

      @x = :b
      @y = :b
    end

    class C < B
      @x = :c
      @z = :c
    end
  }

  context "A" do
    subject { A }

    it { should_not respond_to :deep_class_variable_get }
  end

  context "B" do
    it { B.deep_class_variable_get(:@x).should == :b }
    it { B.deep_class_variable_get(:@y).should == :b }
    it { B.deep_class_variable_get(:@z).should == nil }
    it { B.deep_class_variable_get(:@w).should == nil }
  end

  context "C" do
    it { C.deep_class_variable_get(:@x).should == :c }
    it { C.deep_class_variable_get(:@y).should == :b }
    it { C.deep_class_variable_get(:@z).should == :c }
    it { C.deep_class_variable_get(:@w).should == nil }
  end
end






