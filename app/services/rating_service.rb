class RatingService
  def self.rating_text(rating) # rubocop:disable Metrics/MethodLength
    case rating
    when 'A'
      'excellent'
    when 'B'
      'good'
    when 'C'
      'barely acceptable'
    when 'D'
      'bad'
    when 'F'
      'very bad'
    else
      'unknown'
    end
  end
end
