class Band < ApplicationRecord
  has_one_attached :profile_picture
  has_and_belongs_to_many :posts
  has_many :shows # Assuming shows are associated with bands
  has_and_belongs_to_many :genres

  validates :band_name, presence: true
  validate :profile_picture_size

    def pending?
    !approved
  end
end

  private

  # Custom validation method to check file size
  def profile_picture_size
    if profile_picture.attached? && profile_picture.byte_size > 5.megabytes
      errors.add(:profile_picture, "should be less than 5MB")
    end
  end

