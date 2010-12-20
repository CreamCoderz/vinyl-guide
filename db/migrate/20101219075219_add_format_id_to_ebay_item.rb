class AddFormatIdToEbayItem < ActiveRecord::Migration
  def self.get_format(format_name)
    result = execute(%|select id from formats where name='#{format_name}'|)
    row = result.fetch_row
    id = row ? row.first : nil
    id
  end

  def self.up
    add_column :ebay_items, :format_id, :integer
    lp_id = get_format('LP')
    ep_id = get_format('EP')
    single_id = get_format('Single')
    execute(%|update ebay_items set format_id=#{lp_id} where size="LP (12-Inch)" or size="LP" or size='12"'|) if lp_id
    execute(%|update ebay_items set format_id=#{ep_id} where size='EP, Maxi (10, 12-Inch)' or size='10"' or size='Single, EP (12-Inch)'|) if ep_id
    execute(%|update ebay_items set format_id=#{single_id} where size='7"' or size="Single (7-Inch)"|) if single_id
    add_index :ebay_items, :format_id
  end

  def self.down
    remove_index :ebay_items, :format_id
    remove_column :ebay_items, :format_id
  end
end
