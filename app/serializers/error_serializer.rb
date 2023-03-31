class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_json
    {
      errors: [
        {
          status: "400"
          title: "bad request"
        }
      ]
    }
  end
end