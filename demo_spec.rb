# frozen_string_literal: true

$LOAD_PATH.unshift('.')
require 'micro_spec'

class Demo
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

MicroSpec.describe Demo do
  it 'can use described_class' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
  end

  it 'has multiple expect statements' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')

    demo.name = 'Bub'
    expect(demo.name).to eq('Bub')
  end

  it 'fails' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Bub'
    expect(demo.name).to eq('Bob')
  end

  it 'fails again' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Burt'
    expect(demo.name).to eq('Bob')
  end

  it 'fails another time' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Brett'
    expect(demo.name).to eq('Bob')
  end

  it 'fails one last time' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Ben'
    expect(demo.name).to eq('Bob')
  end
end
