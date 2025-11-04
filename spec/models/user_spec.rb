require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is invalid without a name' do
      user = User.new(email: 'elena@example.com', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an email' do
      user = User.new(name: 'Elena', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is invalid with a duplicate email' do
      User.create!(name: 'Elena', email: 'elena@example.com', password: 'password')
      duplicate_user = User.new(name: 'Another', email: 'elena@example.com', password: 'password123')
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to include('has already been taken')
    end
  end

  describe '#unique_skills' do
    let(:user) { User.create!(name: 'Elena', email: 'elena@example.com', password: 'password') }

    it 'exists for a user' do
      expect { user.unique_skills }.not_to raise_error
    end

    context 'when the user has no certificates' do
      it 'returns an empty array' do
        expect(user.unique_skills).to eq([])
      end
    end

    context 'when the user has certificates with skills' do
      let(:issuer) { Issuer.create!(name: 'SkillCert Inc.', created_by: user.id) }
      let(:ruby) { Skill.create!(name: 'Ruby', created_by: user.id) }
      let(:sql) { Skill.create!(name: 'SQL', created_by: user.id) }

      before do
        cert1 = Certificate.new(name: 'Ruby Cert', issued_on: '2024-01-15', user: user, issuer: issuer)
        cert1.skills << ruby
        cert1.save!
        cert2 = Certificate.new(name: 'SQL Cert', issued_on: '2024-01-15', user: user, issuer: issuer)
        cert2.skills << sql
        cert2.skills << ruby
        cert2.save!
      end

      it 'returns all unique skills associated with the user' do
        expect(user.unique_skills.map(&:name)).to contain_exactly('Ruby', 'SQL')
      end
    end
  end

  describe '#certificates_by_skill' do
    let(:user) { User.create!(name: 'Elena', email: 'elena@example.com', password: 'password') }

    it 'exists for a user' do
      expect { user.certificates_by_skill('Ruby') }.not_to raise_error
    end

    context 'when the user has no certificates' do
      it 'returns an empty array' do
        expect(user.certificates_by_skill('Ruby')).to eq([])
      end
    end

    context 'when the user has certificates but none with the given skill' do
      let(:issuer) { Issuer.create!(name: 'SkillCert Inc.', created_by: user.id) }
      let(:sql) { Skill.create!(name: 'SQL', created_by: user.id) }

      before do
        cert = Certificate.new(name: 'SQL Cert', issued_on: '2024-01-15', user: user, issuer: issuer)
        cert.skills << sql
        cert.save!
      end

      it 'returns an empty array for unmatched skill' do
        expect(user.certificates_by_skill('Ruby')).to eq([])
      end
    end

    context 'when the user has certificates with the given skill' do
      let(:issuer) { Issuer.create!(name: 'SkillCert Inc.', created_by: user.id) }
      let(:ruby) { Skill.create!(name: 'Ruby', created_by: user.id) }

      let!(:cert1) do
        Certificate.new(name: 'Ruby Cert 1', issued_on: '2024-01-15', user: user, issuer: issuer).tap { |c| c.skills << ruby; c.save! }
      end
      let!(:cert2) do
        Certificate.new(name: 'Ruby Cert 2', issued_on: '2024-01-15', user: user, issuer: issuer).tap { |c| c.skills << ruby; c.save! }
      end

      before do
        # skills already attached during creation
      end

      it 'returns all certificates that include the given skill' do
        result = user.certificates_by_skill('Ruby').map(&:name)
        expect(result).to contain_exactly('Ruby Cert 1', 'Ruby Cert 2')
      end
    end
  end
end
