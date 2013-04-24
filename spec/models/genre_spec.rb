require 'spec_helper'

describe Genre do
  it { should validate_uniqueness_of(:name) }
end