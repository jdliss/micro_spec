# frozen_string_literal: true

require 'json'
require 'colorize'

module MicroSpec
  TestPass = Class.new(StandardError)

  def self.describe(constant, &block)
    $spec_queue = Queue.new

    Object.class_eval(
      <<~BODY
        def described_class
          #{constant}
        end

        def it(spec_name, &block)
          $spec_name = spec_name
          begin
            block.call
            puts "  It '\#{$spec_name}' passed.".colorize(:green)
          rescue Assertion::Failure => e
            failure_info = JSON.parse(e.message)
            $spec_queue << {
              name: $spec_name,
              status: 'failed',
              expect: failure_info['expect'],
              got: failure_info['got']
            }
          end
        end

        def expect(value)
          Assertion.new(value)
        end
        alias eq expect
      BODY
    )

    printer = Thread.new do
      loop do
        break if $spec_finished && $spec_queue.empty?
        test = $spec_queue.pop
        puts "  It '#{test[:name]}' failed:".colorize(:red)
        puts "    Expected: #{test[:expect].colorize(:yellow)}, Got: #{test[:got].colorize(:yellow)}"
      end
    end

    puts 'Running tests:'
    block.call

    $spec_finished = true
    printer.join
    $spec_name = nil
    $spec_queue = nil
    $spec_finished = nil
  end

  class Assertion
    Failure = Class.new(StandardError)

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def to(assertion_object)
      if @data != assertion_object.data
        data = {
          expect: @data,
          got:    assertion_object.data
        }
        raise Failure, JSON.dump(data)
      end
    end
  end
end
