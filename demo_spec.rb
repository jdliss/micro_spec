$LOAD_PATH.unshift('.')
require 'micro_spec'
require 'demo'

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

  it 'fails' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Burt'
    expect(demo.name).to eq('Bob')
  end

  it 'fails' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Brett'
    expect(demo.name).to eq('Bob')
  end

  it 'fails' do
    demo = described_class.new('Bob')
    expect(demo.name).to eq('Bob')
    demo.name = 'Ben'
    expect(demo.name).to eq('Bob')
  end
end
