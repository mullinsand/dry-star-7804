require 'rails_helper'


RSpec.describe "Doctor Show Page" do
  describe 'as a visistor visiting the doctors show page' do
    before :each do
      Faker::UniqueGenerator.clear

      @hospital = Hospital.create!(name: Faker::Company.unique.name)
      @doctor_1 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      @doctor_2 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      @patient_1 = Patient.create!(name: Faker::Name.unique.name, age: Faker::Number.within(range: 1..100))
      @patient_2 = Patient.create!(name: Faker::Name.unique.name, age: Faker::Number.within(range: 1..100))
      @patient_3 = Patient.create!(name: Faker::Name.unique.name, age: Faker::Number.within(range: 1..100))
      @patient_4 = Patient.create!(name: Faker::Name.unique.name, age: Faker::Number.within(range: 1..100))
      @doctor_1.patients << @patient_1
      @doctor_1.patients << @patient_2
      @doctor_1.patients << @patient_3
      @doctor_2.patients << @patient_4
    end

    describe 'I see all of the doctors information' do
      it 'has the name, specialty, and university of the doctor' do
        require 'pry'; binding.pry
        visit doctor_path(@doctor_1)
        within "#doctor_attributes" do
          expect(page).to have_content(@doctor_1.name)
          expect(page).to have_content(@doctor_1.specialty)
          expect(page).to have_content(@doctor_1.university)
        end

      end

      it 'has the name of the doctors hospital' do
        within "#doctor_hospital" do
          expect(page).to have_content(@doctor_1.hospital)
        end

      end

      it 'has a list of all the patients assigned to this doctor' do
        doc1_patients = [@patient_1, @patient_2, @patient_3]
        within "#doctor_patients" do
          doc1_patients.each do |patient|
            within "#patient_#{patient.id}" do
              expect(page).to have_content(patient.name)
            end
          end
        end
      end
    end
  end
end