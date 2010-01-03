module BaseSpecCase

  def make_success_response(body)
    make_response(body, 2)
  end

  def make_not_found_response(body)
    make_response(body, 4)
  end

  private

  def make_response(body, response_code_category)
    response = SettableHTTPSuccessResponse.new("1.1", response_code_category, "UNUSED")
    response.body = body
    response
  end
end