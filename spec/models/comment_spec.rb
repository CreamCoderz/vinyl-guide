require 'spec_helper'

describe Comment do
  it { should belong_to(:parent, :polymorphic => true) }
  it { should belong_to(:user) }

  it { should validate_presence_of(:parent) }

  it { should validate_presence_of(:body) }
  it { should validate_length_of(:body, :maximum => Comment::MAX_LENGTH)}

  it { should validate_presence_of(:user) }

end