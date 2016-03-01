class ConferencesController < ApplicationController
  before_action :authenticate_conference_organizer!, only: [:edit]

  def index
    @conferences = policy_scope(Conference)
  end

  def show
    authorize current_conference
    @conference = ConferencePresenter.new(current_conference)
  end

  def edit
    authorize current_conference
    if current_conference.approved_at?
      redirect_to current_conference
    else
      redirect_to new_conference_approval_path(current_conference)
    end
  end

  private

  def current_conference
    @current_conference ||= Conference.find_by_twitter_handle!(params[:id])
  end
end
