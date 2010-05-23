module EbayItemsDetailsParserHelper
  def make_multiple_items_response(items_xml)
    '<?xml version="1.0" encoding="UTF-8"?>
  <GetMultipleItemsResponse xmlns="urn:ebay:apis:eBLBaseComponents">
    <Timestamp>2009-07-03T23:44:00.302Z</Timestamp>
    <Ack>Success</Ack>
    <Build>e623__Bundled_9520957_R1</Build>
    <Version>623</Version>
    <CorrelationID>get multiple items</CorrelationID>' +
            items_xml +
            '</GetMultipleItemsResponse>'
  end

  def check_tetrack_item(actual_tetrack_item)
    check_ebay_item(TETRACK_EBAY_ITEM, actual_tetrack_item)
  end

  def check_garnet_item(actual_garnet_silk_item)
    check_ebay_item(GARNET_EBAY_ITEM, actual_garnet_silk_item)
  end

  def check_ebay_item_data(actual_item, description, itemid, endtime, starttime, url, image, bidcount, price, sellerid)
    actual_item.description.should == description
    actual_item.itemid.should == itemid
    actual_item.endtime.should == endtime
    actual_item.starttime.should == starttime
    actual_item.url.should == url
    actual_item.galleryimg.should == image
    actual_item.bidcount.should == bidcount
    actual_item.price.should == price
    actual_item.sellerid.should == sellerid
  end

  def check_ebay_item(expected_item, actual_item)
    actual_item.should == expected_item
  end
end