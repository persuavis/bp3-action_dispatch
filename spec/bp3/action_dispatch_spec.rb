# frozen_string_literal: true

require 'bp3-action_dispatch'

RSpec.describe Bp3::ActionDispatch do
  it "has a version number" do
    expect(Bp3::ActionDispatch::VERSION).not_to be nil
  end

  describe 'config' do
    it 'supports site_class(_name)' do
      described_class.site_class_name = 'Bp3' # usually this would be an ActiveRecord model
      expect(described_class.site_class).to eq(Bp3)
    end
  end
end
