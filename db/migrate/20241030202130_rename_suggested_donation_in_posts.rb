class RenameSuggestedDonationInPosts < ActiveRecord::Migration[7.2]
  def change
    rename_column :posts, :Suggested_Donation, :suggested_donation
  end
end
