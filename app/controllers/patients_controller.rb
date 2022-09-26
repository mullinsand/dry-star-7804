class PatientsController < ApplicationController
  def index
    @patients = Patient.adult_patients_alpha
  end
end