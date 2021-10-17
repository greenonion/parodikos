# frozen_string_literal: true

RSpec.describe Parodikos::Client do
  let(:cl) { described_class.new("name") }

  it 'has a name' do
    expect(cl.name).to eq('name')
  end
end
