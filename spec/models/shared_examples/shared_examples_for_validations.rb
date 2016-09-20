RSpec.shared_examples 'validates url' do
  let(:model) { described_class.name.underscore.to_sym }

  it 'validates that url is a url' do
    expect(Fabricate.build(model, url: 'foo')).to_not be_valid
    expect(Fabricate.build(model, url: 'http://foo.com')).to be_valid
    expect(Fabricate.build(model, url: 'https://foo.co.uk')).to be_valid
  end
end
