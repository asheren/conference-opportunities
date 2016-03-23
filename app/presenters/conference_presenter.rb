class ConferencePresenter < Struct.new(:instance)
  extend Forwardable
  def_delegators :instance, :logo_url, :name, :tweets, :hashtag, :code_of_conduct_url

  def twitter_name
    "@#{instance.twitter_handle}"
  end

  def twitter_url
    "https://twitter.com/#{instance.twitter_handle}"
  end

  def cfp_deadline
    format_date instance.cfp_deadline
  end

  def speaker_notification_deadline
    format_date instance.speaker_notification_deadline
  end

  def begin_date
    format_date instance.begin_date
  end

  def end_date
    format_date instance.end_date
  end

  def has_diversity_scholarships
    instance.has_diversity_scholarships ? "Yes" : "No"
  end

  def has_childcare
    instance.has_childcare ? "Yes" : "No"
  end

  def has_honorariums
    instance.has_honorariums ? "Yes" : "No"
  end

  def has_lodging_funding
    instance.has_lodging_funding ? "Yes" : "No"
  end

  def has_travel_funding
    instance.has_travel_funding ? "Yes" : "No"
  end

  def location
    instance.location || 'unknown'
  end

  def cfp_url
    instance.cfp_url || 'none'
  end


  def website_url
    instance.website_url || 'none'
  end

  def description
    instance.description || 'none'
  end

  private

  def format_date(date)
    if date
      date.strftime("%B %-d, %Y")
    else
      'unknown'
    end
  end
end
