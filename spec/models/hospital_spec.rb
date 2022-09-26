require 'rails_helper'

RSpec.describe Hospital do
  it {should have_many :doctors}

  describe 'instance methods' do
    describe 'doctors_by_patient_count' do
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
      end

      it 'lists all doctors by the number of patients they each have' do
        hos_1_docs = [@doctor_1, @doctor_3, @doctor_2]
        expect(@hospital.doctors_by_patient_count).to eq(hos_1_docs)
        hos_2_docs = [@doctor_4, @doctor_5, @doctor_6]
        expect(@hospital_2.doctors_by_patient_count).to eq(hos_2_docs)
      end

      it 'each doctor record also contains the number of patients each doctor has' do
        expect(@hospital.doctors_by_patient_count[0].patient_count).to eq(4)
        expect(@hospital_2.doctors_by_patient_count[1].patient_count).to eq(3)

      end

      context 'if a doctor has no patients' do
        it 'returns 0 for that doctors patient count' do
          #doctor_6 ([2] position) has no patients
          expect(@hospital_2.doctors_by_patient_count[2].patient_count).to eq(0)
        end
      end
    end
  end
end
