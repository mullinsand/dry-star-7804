require 'rails_helper'

RSpec.describe Patient, type: :model do
  it {should have_many :doctor_patients}
  it {should have_many(:doctors).through(:doctor_patients)}

  describe 'instance methods' do

    describe '#adult_patients_alpha' do
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
      end

      it 'only selects patients with age greater than 18' do
        expect(Patient.adult_patients_alpha).to_not include(@patient_1)
        expect(Patient.adult_patients_alpha).to_not include(@patient_2)
        expect(Patient.adult_patients_alpha).to_not include(@patient_3)

        expect(Patient.adult_patients_alpha).to include(@patient_5)
        expect(Patient.adult_patients_alpha).to include(@patient_6)
        expect(Patient.adult_patients_alpha).to include(@patient_4)
      end

      it 'orders the patients by name A to Z' do
        expect(Patient.adult_patients_alpha).to eq([@patient_5, @patient_6, @patient_4])
      end
    end
  end
end
