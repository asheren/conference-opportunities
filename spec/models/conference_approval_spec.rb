require "rails_helper"

RSpec.describe ConferenceApproval do
  subject(:approval) { ConferenceApproval.new(twitter_handle: 'ham') }

  describe '.from_conference' do
    let(:conference) { Conference.new(twitter_handle: 'tacoconf', name: 'taco', website_url: 'http://example.com/taco') }
    let(:approval) { ConferenceApproval.from_conference(conference) }

    specify { expect(approval.name).to eq(conference.name) }
    specify { expect(approval.logo_url).to eq(conference.logo_url) }
    specify { expect(approval.website_url).to eq(conference.website_url) }
    specify { expect(approval.twitter_handle).to eq(conference.twitter_handle) }
  end

  it { is_expected.to validate_presence_of(:twitter_handle) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:website_url) }

  describe '#to_param' do
    specify { expect(approval.to_param).to eq(approval.twitter_handle) }
  end

  describe '#persisted?' do
    specify { expect(approval).to be_persisted }
  end

  describe '#save' do
    context 'when invalid' do
      it 'returns false' do
        expect(approval.save).to eq(false)
      end
    end

    context 'when valid' do
      let(:conference) { Conference.create!(twitter_handle: 'tacoconf', name: 'taco', website_url: 'http://example.com/taco') }
      let(:approval) { ConferenceApproval.from_conference(conference) }

      before { approval.name = 'not taco' }

      it 'updates the conference attributes' do
        expect {
          approval.save
        }.to change { conference.reload.name }.from('taco').to('not taco')
      end

      it 'approves the conference' do
        expect {
          approval.save
        }.to change { conference.reload.approved_at }.
          from(nil).to(within(2.seconds).of(Time.now))
      end

      context 'when the logo url is not specified' do
        it 'does not set the logo url' do
          expect {
            approval.save
          }.not_to change { conference.reload.logo_url }.from(nil)
        end
      end

      context 'when the logo url is specified' do
        before { approval.logo_url = 'http://example.com/logo.gif' }

        it 'does not set the logo url' do
          expect {
            approval.save
          }.to change { conference.reload.logo_url }.from(nil)
        end
      end
    end
  end
end
