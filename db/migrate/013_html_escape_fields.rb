require File.dirname(__FILE__) + "/../../app/util/ebay/ebayitemsdetailsparserdata"
require 'cgi'
include EbayItemsDetailsParserData

class HtmlEscapeFields < ActiveRecord::Migration

  def self.up
    EbayItem.find(:all).each do |ebay_item|
      ebay_item.title = CGI::unescapeHTML(ebay_item.title).gsub(/&apos;/, "'")
      ebay_item.description = CGI::unescapeHTML(ebay_item.description).gsub(/&apos;/, "'")
      ebay_item.save
    end
  end

  def self.down
    EbayItem.find(:all).each do |ebay_item|
      ebay_item.title = CGI::escapeHTML(ebay_item.title).gsub(/'/, '&apos;')
      ebay_item.description = CGI::escapeHTML(ebay_item.description).gsub(/'/, '&apos;')
      ebay_item.save
    end
  end

end