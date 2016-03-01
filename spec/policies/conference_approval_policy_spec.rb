require "rails_helper"

RSpec.describe ConferenceApprovalPolicy do
  let(:approval) { ConferenceApproval.new(twitter_handle: "handleconf") }
  let(:conference) { Conference.create(twitter_handle: "handleconf") }
  let(:organizer) { ConferenceOrganizer.create(conference: conference) }

  subject(:policy) { ConferenceApprovalPolicy.new(organizer, approval) }

  describe "#new?" do
    context "when the conference organizer manages the conference" do
      it { is_expected.to be_new }
    end

    context "when the conference organizer does NOT manage the conference" do
      let(:conference) { Conference.create(twitter_handle: "otherconf") }

      it { is_expected.not_to be_new }
    end
  end

  describe "#create?" do
    context "when the conference organizer manages the conference" do
      it { is_expected.to be_new }
    end

    context "when the conference organizer does NOT manage the conference" do
      let(:conference) { Conference.create(twitter_handle: "otherconf") }

      it { is_expected.not_to be_new }
    end
  end
end

