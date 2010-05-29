class AutoCompleteSerializer

  def self.make_json_data(items, title_key=:title, id_key=:id)
    #TODO: this code could be refactored into 1 line
    ebay_api_hash = []
    items.each do |ebay_item|
      ebay_api_hash << {title_key => ebay_item.title, id_key => ebay_item.id}
    end
    ebay_api_hash
  end
end