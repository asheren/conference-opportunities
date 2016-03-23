require "rails_helper"

RSpec.feature "Edit a conference", :js do
  let!(:conference) do
    Conference.create!(
      name: "Variable conference",
      twitter_handle: "varcon",
      description: "Things that change",
      approved_at: 1.day.ago,
    )
  end
  let(:valid_twitter_auth) do
    OmniAuth::AuthHash.new(
      provider: "twitter",
      uid: "654321",
      info: {nickname: "varcon"}
    )
  end

  before do
    OmniAuth.config.mock_auth[:twitter] = valid_twitter_auth
  end

  scenario "a conference organizer can edit their conference", :chrome do
    visit root_path
    click_on "Log in with Twitter"

    visit edit_conference_path(conference)
    expect(page).to have_content "List your conference"

    fill_in "CFP deadline", with: "04/01/2019"
    fill_in "CFP URL", with: "http://varcon.example.org/cfps"
    fill_in "Conference begin date", with: "04/03/2020"
    fill_in "Conference end date", with: "04/05/2020"
    check "Speaker travel funding provided"
    check "Speaker lodging funding provided"
    check "Speaker honorarium provided"
    check "Diversity scholarships available"
    check "Childcare provided"
    fill_in "Code of conduct URL", with: "http://varcon.example.org/codeofconduct"
    fill_in "Speaker notification deadline", with: "10/01/2019"
    fill_in "Hashtag", with: "#varcon"

    click_on "Create listing"

    expect(current_path).to eq(conference_path(conference))

    expect(definition_value("CFP deadline")).to eq "April 1, 2019"
    expect(definition_value("CFP URL")).to eq "http://varcon.example.org/cfps"
    expect(definition_value("Conference begin date")).to eq "April 3, 2020"
    expect(definition_value("Conference end date")).to eq "April 5, 2020"

    expect(definition_value("Speaker travel funding provided")).to eq "Yes"
    expect(definition_value("Speaker lodging funding provided")).to eq "Yes"
    expect(definition_value("Speaker honorarium provided")).to eq "Yes"
    expect(definition_value("Diversity scholarships available")).to eq "Yes"
    expect(definition_value("Childcare available")).to eq "Yes"

    expect(definition_value("Code of conduct URL")).to eq "http://varcon.example.org/codeofconduct"
    expect(definition_value("Speaker notification deadline")).to eq "October 1, 2019"
    expect(definition_value("Hashtag")).to eq "#varcon"
  end

  def definition_value(term)
    find(:xpath, "//dt[text()='#{term}']/following-sibling::dd[1]").text
  end
end
