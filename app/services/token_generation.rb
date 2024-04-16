class TokenGeneration
  def initialize
    @last_sequence_number = Order.maximum(:token_number) || 0
  end

  def generate_sequence_token = @last_sequence_number += 1
end
