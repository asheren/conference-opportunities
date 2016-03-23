require 'rails_helper'

RSpec.describe ConferencePresenter do
  let(:conference) do
    Conference.new(
      logo_url: 'http://example.com/logo.png',
      name: 'Nameconf',
      twitter_handle: 'nameconf',
      hashtag: '#nameconf',
      location: 'Dystopia',
      website_url: 'http://example.com',
      description: 'A conference on names.',
      cfp_deadline: DateTime.parse('April 3, 1980'),
      cfp_url: 'https://example.com/cfps.aspx',
      speaker_notification_deadline: DateTime.parse('April 4, 1980'),
      begin_date: DateTime.parse('March 15, 1981'),
      end_date: DateTime.parse('March 16, 1981'),
      code_of_conduct_url: 'https://example.com/coc',
      has_childcare: childcare,
      has_diversity_scholarships: diversity_scholarships,
      has_honorariums: honorariums,
      has_travel_funding: travel_funding,
      has_lodging_funding: lodging_funding,
    )
  end
  let!(:tweet) { conference.tweets.new(twitter_id: 'ham') }
  let(:childcare) { nil }
  let(:diversity_scholarships) { nil }
  let(:honorariums) { nil }
  let(:travel_funding) { nil }
  let(:lodging_funding) { nil }

  subject(:presenter) { ConferencePresenter.new(conference) }

  specify { expect(presenter.logo_url).to eq('http://example.com/logo.png') }
  specify { expect(presenter.name).to eq('Nameconf') }
  specify { expect(presenter.hashtag).to eq('#nameconf') }
  specify { expect(presenter.website_url).to eq('http://example.com') }
  specify { expect(presenter.location).to eq('Dystopia') }
  specify { expect(presenter.description).to eq('A conference on names.') }
  specify { expect(presenter.twitter_name).to eq('@nameconf') }
  specify { expect(presenter.twitter_url).to eq('https://twitter.com/nameconf') }
  specify { expect(presenter.tweets).to eq([tweet]) }
  specify { expect(presenter.cfp_deadline).to be_a String }
  specify { expect(presenter.cfp_deadline).to eq('April 3, 1980') }
  specify { expect(presenter.speaker_notification_deadline).to eq('April 4, 1980') }
  specify { expect(presenter.cfp_url).to eq('https://example.com/cfps.aspx') }
  specify { expect(presenter.begin_date).to eq('March 15, 1981') }
  specify { expect(presenter.end_date).to eq('March 16, 1981') }
  specify { expect(presenter.code_of_conduct_url).to eq('https://example.com/coc') }

  context 'conference has travel funding' do
    let(:travel_funding) { true }
    specify { expect(presenter.has_travel_funding).to eq('Yes') }
  end
  context 'conference does not have travel funding' do
    let(:travel_funding) { false }
    specify { expect(presenter.has_travel_funding).to eq('No') }
  end

  context 'conference has lodging funding' do
    let(:lodging_funding) { true }
    specify { expect(presenter.has_lodging_funding).to eq('Yes') }
  end
  context 'conference does not have lodging funding' do
    let(:lodging_funding) { false }
    specify { expect(presenter.has_lodging_funding).to eq('No') }
  end

  context 'conference has honorariums' do
    let(:honorariums) { true }
    specify { expect(presenter.has_honorariums).to eq('Yes') }
  end
  context 'conference does not have honorariums' do
    let(:honorariums) { false }
    specify { expect(presenter.has_honorariums).to eq('No') }
  end

  context 'conference has diversity scholarships' do
    let(:diversity_scholarships) { true }
    specify { expect(presenter.has_diversity_scholarships).to eq('Yes') }
  end
  context 'conference does not have diversity scholarships' do
    let(:diversity_scholarships) { false }
    specify { expect(presenter.has_diversity_scholarships).to eq('No') }
  end

  context 'conference has childcare' do
    let(:childcare) { true }
    specify { expect(presenter.has_childcare).to eq('Yes') }
  end
  context 'conference does not have childcare' do
    let(:childcare) { false }
    specify { expect(presenter.has_childcare).to eq('No') }
  end

  context 'Optional conference data is left blank' do
    let(:conference) do
      Conference.new(
        logo_url: 'http://example.com/logo.png',
        name: 'nameconf',
        twitter_handle: 'nameconf',
        location: nil,
        website_url: nil,
        description: nil,
        cfp_deadline: nil,
        cfp_url: nil,
        begin_date: nil,
        end_date: nil,
        has_travel_funding: nil,
      )
    end

    specify { expect(presenter.website_url).to eq('none') }
    specify { expect(presenter.location).to eq('unknown') }
    specify { expect(presenter.description).to eq('none') }
    specify { expect(presenter.cfp_deadline).to eq('unknown') }
    specify { expect(presenter.cfp_url).to eq('none') }
    specify { expect(presenter.begin_date).to eq('unknown') }
    specify { expect(presenter.end_date).to eq('unknown') }
  end
end
