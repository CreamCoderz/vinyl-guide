module SeedData
  def self.create_formats
    # Add the default formats
    Format.create(:name => "LP")
    Format.create(:name => "EP")
    Format.create(:name => "Single")
  end
end