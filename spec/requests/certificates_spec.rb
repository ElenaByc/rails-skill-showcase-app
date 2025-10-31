require 'rails_helper'

RSpec.describe 'Certificates', type: :request do
  let(:user) { User.create!(name: 'Test User', email: 'test@example.com', password: 'password') }
  let(:issuer) { Issuer.create!(name: 'Test Issuer', created_by: user.id) }
  let(:skill) { Skill.create!(name: 'Ruby', created_by: user.id) }

  def login(user)
    post login_path, params: { email: user.email, password: 'password' }
  end

  describe 'POST /certificates' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          certificate: {
            name: 'Ruby on Rails Certificate',
            issued_on: '2024-01-15',
            verification_url: 'https://example.com/verify/123',
            issuer_id: issuer.id,
            skill_ids: [ skill.id ]
          }
        }
      end

      it 'creates a new certificate' do
        login(user)
        expect {
          post certificates_path, params: valid_params
        }.to change(Certificate, :count).by(1)
      end

      it 'assigns the correct user to the certificate' do
        login(user)
        post certificates_path, params: valid_params
        certificate = Certificate.last
        expect(certificate.user).to eq(user)
      end

      it 'assigns skills to the certificate' do
        login(user)
        post certificates_path, params: valid_params
        certificate = Certificate.last
        expect(certificate.skills).to include(skill)
      end

      it 'redirects to user dashboard with success message' do
        login(user)
        post certificates_path, params: valid_params
        expect(response).to redirect_to(dashboard_path)
        follow_redirect!
        expect(flash[:notice]).to eq('Certificate was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          certificate: {
            name: '',
            issued_on: '',
            issuer_id: issuer.id,
            skill_ids: [ skill.id ]
          }
        }
      end

      it 'does not create a new certificate' do
        login(user)
        expect {
          post certificates_path, params: invalid_params
        }.not_to change(Certificate, :count)
      end

      it 'renders the new template' do
        login(user)
        post certificates_path, params: invalid_params
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'preserves skill selection on validation error' do
        login(user)
        post certificates_path, params: invalid_params
        certificate = assigns(:certificate)
        expect(certificate.skill_ids).to include(skill.id)
      end
    end
  end

  describe 'PATCH /certificates/:id' do
    let(:certificate) do
      Certificate.new(
        name: 'Original Certificate',
        issued_on: '2024-01-01',
        user: user,
        issuer: issuer
      ).tap { |c| c.skills << skill; c.save! }
    end

    context 'with valid parameters' do
      let(:valid_params) do
        {
          certificate: {
            name: 'Updated Certificate Name',
            issued_on: '2024-02-01',
            verification_url: 'https://example.com/verify/456',
            issuer_id: issuer.id,
            skill_ids: [ skill.id ]
          }
        }
      end

      it 'updates the certificate' do
        login(user)
        patch certificate_path(certificate), params: valid_params
        certificate.reload
        expect(certificate.name).to eq('Updated Certificate Name')
        expect(certificate.issued_on).to eq(Date.parse('2024-02-01'))
        expect(certificate.verification_url).to eq('https://example.com/verify/456')
      end

      it 'updates the certificate skills' do
        login(user)
        patch certificate_path(certificate), params: valid_params
        certificate.reload
        expect(certificate.skills).to include(skill)
      end

      it 'redirects to user dashboard with success message' do
        login(user)
        patch certificate_path(certificate), params: valid_params
        expect(response).to redirect_to(dashboard_path)
        follow_redirect!
        expect(flash[:notice]).to eq('Certificate was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          certificate: {
            name: '',
            issued_on: '',
            issuer_id: issuer.id,
            skill_ids: [ skill.id ]
          }
        }
      end

      it 'does not update the certificate' do
        original_name = certificate.name
        login(user)
        patch certificate_path(certificate), params: invalid_params
        certificate.reload
        expect(certificate.name).to eq(original_name)
      end

      it 'renders the edit template' do
        login(user)
        patch certificate_path(certificate), params: invalid_params
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'preserves skill selection on validation error' do
        login(user)
        patch certificate_path(certificate), params: invalid_params
        certificate.reload
        expect(certificate.skill_ids).to include(skill.id)
      end
    end
  end

  describe 'DELETE /certificates/:id' do
    let!(:certificate) do
      Certificate.new(
        name: 'Certificate to Delete',
        issued_on: '2024-01-01',
        user: user,
        issuer: issuer
      ).tap { |c| c.skills << skill; c.save! }
    end

    it 'deletes the certificate' do
      login(user)
      expect {
        delete delete_certificate_path(certificate)
      }.to change(Certificate, :count).by(-1)
    end

    it 'redirects to user dashboard with success message' do
      login(user)
      delete delete_certificate_path(certificate)
      expect(response).to redirect_to(dashboard_path)
      follow_redirect!
        expect(flash[:notice]).to eq('Certificate was successfully deleted.')
    end
  end

  describe 'GET /certificates/new' do
    it 'renders the new template' do
      login(user)
      get new_certificate_path
      expect(response).to render_template(:new)
      expect(response).to have_http_status(:success)
    end

    it 'assigns a new certificate' do
      login(user)
      get new_certificate_path
      expect(assigns(:certificate)).to be_a_new(Certificate)
    end

    it 'assigns user issuers and skills' do
      login(user)
      get new_certificate_path
      expect(assigns(:user_issuers)).to eq(user.created_issuers)
      expect(assigns(:user_skills)).to eq(user.created_skills)
    end
  end

  describe 'GET /certificates/:id/edit' do
    let(:certificate) do
      Certificate.new(
        name: 'Certificate to Edit',
        issued_on: '2024-01-01',
        user: user,
        issuer: issuer
      ).tap { |c| c.skills << skill; c.save! }
    end

    it 'renders the edit template' do
      login(user)
      get edit_certificate_path(certificate)
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:success)
    end

    it 'assigns the correct certificate' do
      login(user)
      get edit_certificate_path(certificate)
      expect(assigns(:certificate)).to eq(certificate)
    end

    it 'assigns user issuers and skills' do
      login(user)
      get edit_certificate_path(certificate)
      expect(assigns(:user_issuers)).to eq(user.created_issuers)
      expect(assigns(:user_skills)).to eq(user.created_skills)
    end
  end
end
