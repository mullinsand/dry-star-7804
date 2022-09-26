require 'rails_helper'


RSpec.describe "Hospital Show Page" do
  describe 'as a visitor visiting the hospital show page' do
    before :each do
      Faker::UniqueGenerator.clear

      @hospital = Hospital.create!(name: Faker::Company.unique.name)
      @hospital_2 = Hospital.create!(name: Faker::Company.unique.name)
      @doctor_1 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      @doctor_2 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      @doctor_3 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital)
      
      @doctor_4 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital_2)
      @doctor_5 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital_2)
      @doctor_6 = Doctor.create!(name: Faker::Name.unique.name, specialty: Faker::Company.unique.industry , university: Faker::Educator.unique.university, hospital: @hospital_2)
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
      #doctor_1 has 4 patients
      @doctor_3.patients << @patient_4
      @doctor_3.patients << @patient_3
      @doctor_3.patients << @patient_6

      @doctor_2.patients << @patient_3

      #hospital_2
      @doctor_4.patients << @patient_1
      @doctor_4.patients << @patient_2
      @doctor_4.patients << @patient_3
      @doctor_4.patients << @patient_5

      @doctor_5.patients << @patient_4
      @doctor_5.patients << @patient_3
      @doctor_5.patients << @patient_5
      #doctor_6 has no patients

      visit hospital_path(@hospital)
    end

    describe 'I see hospitals name' do
      it 'has the hospitals name,' do


        within "#hospital_attributes" do
          expect(page).to have_content(@hospital.name)
          expect(page).to_not have_content(@hospital_2.name)
        end

      end
    end
    
    describe 'it has a list of all doctors associtated with this hospital' do
      it 'list of doctors contains all doctors part of hospital with their patient count' do
        hos_1_docs = [[@doctor_1, 4], [@doctor_3, 3], [@doctor_2, 1]]
        within "#hospital_doctors" do
          hos_1_docs.each do |doctor|
            within "#doctor_#{doctor[0].id}" do
              expect(page).to have_content(doctor[0].name)
              expect(page).to have_content(doctor[1])
            end
          end
          expect(page).to_not have_content(@doctor_5.name)
        end
      end

      it 'list of doctors is ordered by most patients' do
        hos_1_docs = [@doctor_1, @doctor_3, @doctor_2]

        within "#hospital_doctors" do
          expect(@doctor_1.name).to appear_before(@doctor_3.name)
          expect(@doctor_3.name).to appear_before(@doctor_2.name)
        end
      end
    end
  end
end