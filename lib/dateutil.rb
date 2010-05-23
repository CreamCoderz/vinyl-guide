require 'rubygems'
require 'active_support'
require 'time'

module DateUtil

  def date_to_utc(date)
    date.to_time.strftime("%Y-%m-%dT%H:%M:%S.000Z")
  end

  def utc_to_date(utc)
    Time.iso8601(utc)
  end

end