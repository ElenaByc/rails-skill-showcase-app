require 'rails_helper'

RSpec.describe Certificate, type: :model do
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password') }
  let(:issuer) { Issuer.create!(name: 'Test Issuer', created_by: user.id) }

  describe 'validations' do
    it 'is invalid without a name' do
      certificate = Certificate.new(
        issued_on: '2024-01-15',
        user: user,
        issuer: issuer
      )
      expect(certificate).not_to be_valid
      expect(certificate.errors[:base]).to include("Certificate name can't be blank")
    end

    it 'is invalid without an issued_on date' do
      certificate = Certificate.new(
        name: 'Test Certificate',
        user: user,
        issuer: issuer
      )
      expect(certificate).not_to be_valid
      expect(certificate.errors[:base]).to include("Issue date can't be blank")
    end

    it 'is valid with valid attributes' do
      certificate = Certificate.new(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        user: user,
        issuer: issuer
      )
      expect(certificate).to be_valid
    end

    it 'is valid with a valid verification URL' do
      certificate = Certificate.new(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        verification_url: 'https://example.com/verify/123',
        user: user,
        issuer: issuer
      )
      expect(certificate).to be_valid
    end

    it 'is invalid with an invalid verification URL format' do
      certificate = Certificate.new(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        verification_url: 'not-a-valid-url',
        user: user,
        issuer: issuer
      )
      expect(certificate).not_to be_valid
      expect(certificate.errors[:verification_url]).to include('is invalid')
    end

    it 'is valid with blank verification URL' do
      certificate = Certificate.new(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        verification_url: '',
        user: user,
        issuer: issuer
      )
      expect(certificate).to be_valid
    end

    it 'is valid with nil verification URL' do
      certificate = Certificate.new(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        verification_url: nil,
        user: user,
        issuer: issuer
      )
      expect(certificate).to be_valid
    end
  end

  describe 'associations' do
    let(:certificate) do
      Certificate.create!(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        user: user,
        issuer: issuer
      )
    end

    it 'belongs to a user' do
      expect(certificate.user).to eq(user)
    end

    it 'belongs to an issuer' do
      expect(certificate.issuer).to eq(issuer)
    end

    it 'has many certificate_skills' do
      expect(certificate.certificate_skills).to be_empty
    end

    it 'has many skills through certificate_skills' do
      expect(certificate.skills).to be_empty
    end

    it 'can have skills assigned' do
      skill = Skill.create!(name: 'Ruby', created_by: user.id)
      certificate.skills << skill
      expect(certificate.skills).to include(skill)
    end

    it 'destroys associated certificate_skills when destroyed' do
      skill = Skill.create!(name: 'Ruby', created_by: user.id)
      certificate.skills << skill
      certificate_skill = certificate.certificate_skills.first
      
      expect {
        certificate.destroy
      }.to change { CertificateSkill.count }.by(-1)
    end
  end

  describe 'skill assignment' do
    let(:certificate) do
      Certificate.create!(
        name: 'Test Certificate',
        issued_on: '2024-01-15',
        user: user,
        issuer: issuer
      )
    end

    let(:skill1) { Skill.create!(name: 'Ruby', created_by: user.id) }
    let(:skill2) { Skill.create!(name: 'Rails', created_by: user.id) }

    it 'can assign multiple skills' do
      certificate.skills = [skill1, skill2]
      expect(certificate.skills).to contain_exactly(skill1, skill2)
    end

    it 'can update skills' do
      certificate.skills = [skill1]
      certificate.skills = [skill2]
      expect(certificate.skills).to contain_exactly(skill2)
    end

    it 'can clear all skills' do
      certificate.skills = [skill1, skill2]
      certificate.skills = []
      expect(certificate.skills).to be_empty
    end
  end

  describe 'custom validation methods' do
    describe '#certificate_name_presence' do
      it 'adds error when name is blank' do
        certificate = Certificate.new(issued_on: '2024-01-15', user: user, issuer: issuer)
        certificate.send(:certificate_name_presence)
        expect(certificate.errors[:base]).to include("Certificate name can't be blank")
      end

      it 'does not add error when name is present' do
        certificate = Certificate.new(name: 'Test', issued_on: '2024-01-15', user: user, issuer: issuer)
        certificate.send(:certificate_name_presence)
        expect(certificate.errors[:base]).to be_empty
      end
    end

    describe '#issued_on_presence' do
      it 'adds error when issued_on is blank' do
        certificate = Certificate.new(name: 'Test', user: user, issuer: issuer)
        certificate.send(:issued_on_presence)
        expect(certificate.errors[:base]).to include("Issue date can't be blank")
      end

      it 'does not add error when issued_on is present' do
        certificate = Certificate.new(name: 'Test', issued_on: '2024-01-15', user: user, issuer: issuer)
        certificate.send(:issued_on_presence)
        expect(certificate.errors[:base]).to be_empty
      end
    end
  end
end
