class Genre < ApplicationRecord
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :bands
  validates :name, presence: true, uniqueness: true

  before_destroy :check_associations

  private

  def check_associations
    if bands.any?
      errors.add(:base, "Cannot delete genre with associated bands.")
      throw(:abort)
    end
  end
end
