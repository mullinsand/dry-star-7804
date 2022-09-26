class Patient < ApplicationRecord
  has_many :doctor_patients
  has_many :doctors, through: :doctor_patients

  def self.adult_patients_alpha
    where("age > 18")
    .order(:name)
  end
end
