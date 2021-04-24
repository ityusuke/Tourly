class Spot < ApplicationRecord
  belongs_to :tour, inverse_of: :spots
  mount_uploader :spot_images, SpotImagesUploader
end
