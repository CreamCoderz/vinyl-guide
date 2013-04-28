require 'spec_helper'

describe GenreAlias do
  context "validations" do
    before { Factory.create(:genre) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :genre_id }
    it { should validate_uniqueness_of :name }
  end

  context "associations" do
    it { should belong_to :genre }
  end
end