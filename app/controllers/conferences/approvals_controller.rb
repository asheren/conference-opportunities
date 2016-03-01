class Conferences::ApprovalsController < ApplicationController
  before_action :authenticate_conference_organizer!, only: [:new, :create]

  def new
    conference = Conference.find_by!(twitter_handle: params[:conference_id])
    @conference_approval = ConferenceApproval.from_conference(conference)
    authorize @conference_approval
  end

  def create
    @conference_approval = ConferenceApproval.new(conference_approval_params)
    authorize @conference_approval
    if @conference_approval.save
      redirect_to conference_path(params[:conference_id])
    else
      render :new
    end
  end

  private

  def conference_approval_params
    params.require(:conference_approval).permit(:name, :website_url).merge(twitter_handle: params[:conference_id])
  end
end
