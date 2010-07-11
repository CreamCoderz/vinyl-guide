class RemoveDuplicateEbayItems < ActiveRecord::Migration
  def self.up
    add_index :ebay_items, [:itemid]

    deleted_items = []
    total_items = ActiveRecord::Base.connection.execute("select count(*) from ebay_items").fetch_row()[0].to_i
    num_iterations = total_items <= 100 ? 1 : (total_items/100 + 1)
    num_iterations.times do |i|
      puts "cycle #{i} of #{num_iterations} completed #{(i.to_f/num_iterations.to_f) * 100}"
      ebay_items = EbayItem.find(:all, :limit => 100, :offset => i * 100)
      ebay_items.each do |ebay_item|
        next if deleted_items.include? ebay_item.id
        EbayItem.find_by_sql("select * from ebay_items where itemid=#{ebay_item.itemid}").each do |item|
           unless item.id == ebay_item.id
             item.delete
             deleted_items << item.id
             puts "item removed: #{item.id}" 
           end
        end
      end
    end
    end_items = ActiveRecord::Base.connection.execute("select count(*) from ebay_items").fetch_row()[0].to_i
    puts "initial item count: #{total_items}"
    puts "end item count: #{end_items}"
    puts "difference: #{total_items - end_items}"
  end

  def self.down
    remove_index :ebay_items, [:itemid]
  end
end
