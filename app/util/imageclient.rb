class ImageClient

  def initialize(webclient)
    @webclient = webclient
  end

  def fetch(url)
    response = @webclient.get(url)
    if response.kind_of?(Net::HTTPSuccess) && response['content-type'] == 'image/jpeg'
      return response.body
    end
  end
end