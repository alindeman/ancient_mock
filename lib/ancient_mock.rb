require_relative "ancient_mock/version"

module AncientMock
  ExpectationNotSatisfied = Class.new(StandardError)

  class StubTarget
    def initialize(obj)
      @obj = obj
    end

    def to(definition)
      Stubber.for_object(@obj).stub(definition)
    end
  end

  class ExpectationTarget < StubTarget
    def to(definition)
      super
      AncientMock.expectations << definition
    end
  end

  class Stubber
    def self.stubbers
      @stubbers ||= { }
    end

    def self.for_object(obj)
      stubbers[obj.__id__] ||= Stubber.new(obj)
    end

    def self.reset
      stubbers.each_value(&:reset)
      stubbers.clear
    end

    def initialize(obj)
      @obj = obj
      @definitions = []
      @preserved_methods = []
    end

    def stub(definition)
      @definitions << definition

      # preserve the method if already exists
      if @obj.singleton_methods.include?(definition.message)
        @preserved_methods <<
          @obj.method(definition.message)
      end

      definitions = @definitions
      @obj.define_singleton_method(definition.message) do |*arguments|
        definitions.
          reverse.
          find { |d| d.matches?(definition.message, *arguments) }.
          call
      end
    end

    def reset
      @definitions.each do |definition|
        @obj.singleton_class.class_eval do
          remove_method(definition.message) if method_defined?(definition.message)
        end
      end

      @preserved_methods.reverse.each do |method|
        @obj.define_singleton_method(method.name, method)
      end
    end
  end

  class ExpectationDefinition
    attr_reader :message, :return_value

    def initialize(message)
      @message = message
      @invocation_count = 0
    end

    def and_return(return_value)
      @return_value = return_value
      self
    end

    def with(*arguments)
      @arguments = arguments
      self
    end

    def matches?(message, *arguments)
      message == @message &&
        (@arguments.nil? || arguments == @arguments)
    end

    def call
      @invocation_count += 1
      @return_value
    end

    def verify
      if @invocation_count != 1
        raise ExpectationNotSatisfied
      end
    end
  end

  module TestExtensions
    def allow(obj)
      StubTarget.new(obj)
    end

    def expect(obj)
      ExpectationTarget.new(obj)
    end

    def receive(message)
      ExpectationDefinition.new(message)
    end
  end

  def self.reset
    expectations.each(&:verify)
  ensure
    expectations.clear
    Stubber.reset
  end

  def self.expectations
    @expectations ||= []
  end
end

class MiniTest::Unit::TestCase
  include AncientMock::TestExtensions
end
