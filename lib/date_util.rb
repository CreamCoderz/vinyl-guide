require 'rubygems'
require 'active_support'
require 'time'

module DateUtil

  def self.date_to_utc(date)
    date.strftime("%Y-%m-%dT%H:%M:%S.000Z")
  end

  def self.utc_to_date(utc)
    Time.iso8601(utc)
  end

end