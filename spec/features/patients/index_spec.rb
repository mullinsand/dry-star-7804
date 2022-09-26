require 'rails_helper'


RSpec.describe "Patient Index Page" do
  describe 'as a visitor visiting the patient index page' do
    before :each do
      Faker::UniqueGenerator.clear

      @hospital = Hospital.create!(name: Faker::Company.unique.name)
      @hospital_2 = Hospital.create!(name: Faker::Company.unique.name)
      @doctor_1 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      @doctor_2 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      @doctor_3 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital_2)
      @patient_1 = Patient.create!(name: Faker::Name.unique.name, age: Faker::Number.within(range: 1..5))
      @patient_2 = Patient.create!(name: Faker::Name.unique.name, age: Faker::Number.within(range: 6..17))
      @patient_3 = Patient.create!(name: Faker::Name.unique.name, age: 18)
      @patient_4 = Patient.create!(name: "Zebulon B Vance", age: Faker::Number.within(range: 19..100))
      @patient_5 = Patient.create!(name: "Andrewius", age: Faker::Number.within(range: 19..100))
      @patient_6 = Patient.create!(name: "Jack Jack", age: Faker::Number.within(range: 19..100))

      @doctor_1.patients << @patient_1
      @doctor_1.patients << @patient_2
      @doctor_1.patients << @patient_3
      @doctor_1.patients << @patient_5
      @doctor_2.patients << @patient_4

      visit patients_path
    end

    describe 'Adult patients list' do
      it 'lists the names of all adult patients' do
        adult_patients = [@patient_5, @patient_6, @patient_4]

        within "#adult_patients" do
          adult_patients.each do |patient|
            within "#patient_#{patient.id}" do
              expect(page).to have_content(patient.name)
            end
          end
        end

      end

      context 'does not list patients under 19' do
        it 'does not have the names of patients under 19' do
          young_patients = [@patient_1, @patient_2, @patient_3]
          within "#adult_patients" do
            young_patients.each do |patient|
              expect(page).to_not have_content(patient.name)
            end
          end
        end
      end

      it 'lists the names in alphabetical order' do
        within "#adult_patients" do
          expect(@patient_5.name).to appear_before(@patient_6.name)
          expect(@patient_6.name).to appear_before(@patient_4.name)
        end
      end
    end
  end
end