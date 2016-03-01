require 'rails_helper'

RSpec.describe ConferencesController do
  let(:twitter_handle) { "foobar" }
  let(:approved_at) { nil }
  let!(:conference) { Conference.create!(twitter_handle: twitter_handle, approved_at: approved_at) }
  let(:organizer) do
    ConferenceOrganizer.create!(uid: '123', provider: 'twitter',
                               conference: conference)
  end
  let(:other_conference) { Conference.create!(twitter_handle: "other_#{twitter_handle}") }

  describe "GET #show" do
    def make_request(conference)
      get :show, id: conference.twitter_handle
    end

    context "when the conference does not exist" do
      it "raises a not found exception" do
        expect { get :show, id: "fake_twitter_handle" }.
          to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "when the conference is not approved" do
      it "raises a not authorized error" do
        expect { make_request(conference) }.
          to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context "when the conference is approved" do
      let(:approved_at) { Time.now }

      it "is successful" do
        make_request(conference)
        expect(response).to be_success
      end

      it "assigns the conference" do
        make_request(conference)
        expect(assigns(:conference).instance).to eq(conference)
      end
    end
  end

  describe "GET #edit" do
    def make_request(conference)
      get :edit, id: conference.twitter_handle
    end

    context 'when not signed in' do
      it 'boots the browser back to the root path' do
        make_request(conference)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when signed in as a conference organizer' do
      before { sign_in :conference_organizer, organizer }

      context "when the conference does not exist" do
        it "raises a not found exception" do
          expect { get :edit, id: "fake_twitter_handle" }.
            to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when a different organizer owns the conference' do
        it "raises a not authorized error" do
          expect { make_request(other_conference) }.
            to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when the conference is not approved" do
        it "redirects to the conference approval path" do
          make_request(conference)
          expect(response).to redirect_to(new_conference_approval_path(conference))
        end
      end

      context "when the conference has been approved" do
        let(:approved_at) { Time.now }

        it "redirects to the conference show path" do
          make_request(conference)
          expect(response).to redirect_to(conference)
        end
      end
    end
  end

  describe "GET #index" do
    let(:approved_at) { Time.now }
    let!(:other_conference) { Conference.create!(twitter_handle: "other_#{twitter_handle}") }

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns all the approved conferences" do
      get :index
      expect(assigns(:conferences)).to eq([conference])
    end
  end
end
