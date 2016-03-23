class AddConferenceAttributes < ActiveRecord::Migration
  def change
    add_column :conferences, :cfp_deadline, :datetime
    add_column :conferences, :cfp_url, :string
    add_column :conferences, :begin_date, :date
    add_column :conferences, :end_date, :date
    add_column :conferences, :has_travel_funding, :boolean
    add_column :conferences, :has_lodging_funding, :boolean
    add_column :conferences, :has_honorariums, :boolean
    add_column :conferences, :has_diversity_scholarships, :boolean
    add_column :conferences, :has_childcare, :boolean
    add_column :conferences, :code_of_conduct_url, :string
    add_column :conferences, :speaker_notification_deadline, :datetime
    add_column :conferences, :hashtag, :string
  end
end
