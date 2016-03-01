class ConferenceApprovalPolicy < Struct.new(:conference_organizer, :approval)
  def new?
    conference_organizer.conference.twitter_handle == approval.twitter_handle
  end

  def create?
    new?
  end
end
