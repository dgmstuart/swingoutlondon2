RSpec.shared_examples 'sortable' do
  before do
    Fabricate.create(model, name: "#{initial_low}#{high_string}")
    Fabricate.create(model, name: "#{initial_high}#{low_string}")
  end

  subject(:first_item_name) { model_class.all.sorted.first.name }
  it_should_behave_like 'sortable common'
end

RSpec.shared_examples 'sortable by association' do |associated_model_class|
  let(:associated_model) { associated_model_class.name.underscore.to_sym }
  let(:associated_table) { associated_model_class.name.underscore.pluralize.to_sym }

  before do
    instance_1 = Fabricate.create(model)
    Fabricate.create(associated_model, model => instance_1, name: "#{initial_low}#{high_string}")
    instance_2 = Fabricate.create(model)
    Fabricate.create(associated_model, model => instance_2, name: "#{initial_high}#{low_string}")
  end

  subject(:first_item_name) { model_class.all.joins(associated_table).sorted.first.name }
  it_should_behave_like 'sortable common'
end

RSpec.shared_examples 'sortable common' do
  describe 'sorted' do
    let(:model) { described_class.name.underscore.to_sym }
    let(:model_class) { described_class }

    let(:high_string) { 'Love Conquers All' }
    let(:low_string) { 'Lion The Witch and the Wardrobe' }
    let(:initial_low) { nil }
    let(:initial_high) { nil }

    let(:lowest_string) { "#{initial_high}#{low_string}" }

    high_initial_strings = [
      'The ',
      'the ',
    ]
    high_initial_strings.each do |his|
      context "when one name begins with '#{his}'" do
        let(:initial_high) { his }
        it "should sort events ignoring an initial '#{his}'" do
          expect(first_item_name).to eq lowest_string
        end
      end
    end

    low_initial_strings = %W(
      \"
      \'
      \(
    )
    low_initial_strings.each do |lis|
      context "when one name begins with #{lis}" do
        let(:initial_low) { lis }
        it { is_expected.to eq lowest_string }
      end
    end

    context 'when names are in mixed case' do
      let(:high_string) { 'Bananas' }
      let(:low_string) { 'alphabet' }
      it { is_expected.to eq lowest_string }
    end
  end
end
