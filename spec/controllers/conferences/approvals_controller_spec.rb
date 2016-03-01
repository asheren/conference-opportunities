require "rails_helper"

RSpec.describe Conferences::ApprovalsController do
  let(:approved_at) { nil }
  let!(:conference) { Conference.create!(twitter_handle: "myconf", name: 'hamconf', approved_at: approved_at) }
  let(:organizer) do
    ConferenceOrganizer.create!(uid: '123', provider: 'twitter',
                               conference: conference)
  end
  let(:other_conference) { Conference.create!(twitter_handle: "yourconf") }

  describe "GET #new" do
    def make_request(conference)
      get :new, conference_id: conference.twitter_handle
    end

    context "when not signed in" do
      it "redirects to the root path" do
        make_request(conference)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when an organizer is signed in' do
      before { sign_in :conference_organizer, organizer }

      context "when the conference is not owned by the organizer" do
        it "raises a not authorized error" do
          expect { make_request(other_conference) }.
            to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when the conference organizer owns the conference" do
        it "assigns the conference" do
          make_request(conference)
          expect(assigns(:conference_approval).twitter_handle).to eq("myconf")
        end
      end
    end
  end

  describe "POST #create" do
    def make_request(conference, params = {})
      params = {name: conference.name, website_url: 'http://example.com'}.merge(params)
      post :create, conference_id: conference.twitter_handle, conference_approval: params.delete_if { |_, v| v.nil? }
    end

    context "when not signed in" do
      it "redirects to the root path" do
        make_request(conference)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when an organizer is signed in' do
      before { sign_in :conference_organizer, organizer }

      context "when the conference is not owned by the organizer" do
        it "raises a not authorized error" do
          expect { make_request(other_conference) }.
            to raise_error(Pundit::NotAuthorizedError)
        end
      end

      context "when the conference organizer owns the conference" do
        context 'when the approval paramters are invalid' do
          it "renders the form" do
            make_request(conference, name: 'ludditeconf', website_url: nil)
            expect(response).to render_template(:new)
          end
        end

        context 'when the approval paramters are valid' do
          it "redirects to the conference" do
            make_request(conference)
            expect(response).to redirect_to(conference)
          end

          it "approves the conference" do
            expect { make_request(conference) }.
            to change { conference.reload.approved_at }.from(nil)
          end

          it "updates passed in attributes" do
            expect { make_request(conference, name: "Most excellent conf") }.
            to change { conference.reload.name }.to("Most excellent conf")
          end
        end
      end
    end
  end
end
