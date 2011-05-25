require 'net/http'

class SettableHttpClient < Net::HTTP
  attr_reader :host, :port, :path

  #TODO: get rid of unneed init params

  def initialize(foo, bar=nil)
    @xml, @response_code, @path = [], [], []
    @request_count = 0
  end

  def start(host, port)
    @host = host
    @port = port
    yield self
  end

  def set_response(xml, response_code="2")
    @xml.insert(-1, xml)
    @response_code.insert(-1, response_code)
  end

  def get(path)
    @path.insert(-1, path)
    response = SettableHTTPSuccessResponse.new("1.1", @response_code[@request_count], "UNUSED")
    response.body = @xml[@request_count]
    @request_count += 1
    response
  end

  def post(path)
  end
end

class SettableHTTPSuccessResponse < Net::HTTPResponse
  def initialize(version, code, foo)
    @code = code 
  end

  def body= (xml)
    @xml = xml
  end

  def body
    @xml
  end

  def == (another_class)
    Net::HTTPResponse::CODE_CLASS_TO_OBJ[@code] == another_class
  end
end