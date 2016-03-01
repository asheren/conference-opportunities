class ConferenceApproval
  include ActiveModel::Model
  attr_accessor :name, :website_url, :twitter_handle, :logo_url
  validates_presence_of :name, :website_url, :twitter_handle

  def self.from_conference(conference)
    new(
      name: conference.name,
      logo_url: conference.logo_url,
      website_url: conference.website_url,
      twitter_handle: conference.twitter_handle,
    )
  end

  def persisted?
    true
  end

  def to_param
    twitter_handle
  end

  def save
    return false unless valid?
    Conference.
      where(twitter_handle: twitter_handle).
      update_all(conference_attributes)
  end

  private

  def conference_attributes
    attributes = {
      name: name,
      website_url: website_url,
      approved_at: Time.now,
    }
    attributes[:logo_url] = logo_url if logo_url.present?
    attributes
  end
end
