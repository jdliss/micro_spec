$LOAD_PATH.unshift('.')
require 'micro_spec'
require 'demo'

MicroSpec.describe Demo do
  it 'takes a name' do
    demo = described_class.new('bob')
    expect(demo.name).to eq('bob')
  end

  it 'exposes name' do
    demo = described_class.new('bob')
    expect(demo.name).to eq('bob')
    demo.name = 'new name'
    expect(demo.name).to eq('bob')
  end

  it 'exposes name' do
    demo = described_class.new('bob')
    expect(demo.name).to eq('bob')
    demo.name = 'new name'
    expect(demo.name).to eq('bob')
  end

  it 'exposes name' do
    demo = described_class.new('bob')
    expect(demo.name).to eq('bob')
    demo.name = 'new name'
    expect(demo.name).to eq('bob')
  end

  it 'exposes name' do
    demo = described_class.new('bob')
    expect(demo.name).to eq('bob')
    demo.name = 'new name'
    expect(demo.name).to eq('bob')
  end
end
