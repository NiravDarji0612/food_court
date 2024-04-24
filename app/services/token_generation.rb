class TokenGeneration
  def initialize
    @last_sequence_number = Order.last.token_number || 0
  end

  def generate_sequence_token = @last_sequence_number += 1
end
