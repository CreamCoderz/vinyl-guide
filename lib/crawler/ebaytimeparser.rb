require File.dirname(__FILE__) + "/../dateutil"
require 'cobravsmongoose'

class EbayTimeParser

  def self.parse(xml)
    time_data = CobraVsMongoose.xml_to_hash(xml)
    time_in_utc = time_data['GeteBayTimeResponse']['Timestamp']['$']
    DateUtil.utc_to_date(time_in_utc)
  end

end