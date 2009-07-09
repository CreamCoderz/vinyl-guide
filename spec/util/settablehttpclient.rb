class SettableHttpClient<Net::HTTP

  def host
    @host
  end

  def port
    @port
  end

  def path
    @path
  end

  def start(host, port)
    @host = host
    @port = port
    yield self
  end

  def set_response(xml, response_code="2")
    @xml = xml
    @response_code = response_code
  end

  def get(path)
    @path = path
    response = SettableHTTPSuccessResponse.new("1.1", @response_code, "UNUSED")
    response.body = @xml
    response
  end

  def post(path)
    puts path

  end
end

class SettableHTTPSuccessResponse<Net::HTTPResponse
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