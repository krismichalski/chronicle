RSpec.describe 'Authentication', type: :request do
  describe 'POST /oauth/token' do
    describe 'grant_type password' do
      context 'with valid params' do
        let(:user) { create :user, email: 'user@example.com', password: '12345678' }

        context 'without client credentials' do
          it 'returns token' do
            post '/oauth/token', params: {
              'grant_type' => 'password',
              'email' => user.email,
              'password' => '12345678'
            }

            expect(Doorkeeper::AccessToken.count).to eq 1
            expect(Doorkeeper::AccessToken.first.application_id).to eq nil

            expect(json['access_token'].size).to eq 64
            expect(json['refresh_token']).to eq nil
            expect(json['token_type']).to eq 'bearer'
            expect(json['expires_in']).to eq 7200
            expect(json['created_at'].present?).to eq true
            expect(response.status).to eq 200
          end
        end

        context 'with client credentials' do
          let(:client_application) { create :client_application }

          it 'returns token' do
            post '/oauth/token', params: {
              'grant_type' => 'password',
              'email' => user.email,
              'password' => '12345678',
              'client_id' => client_application.uid,
              'client_secret' => client_application.secret
            }

            expect(Doorkeeper::AccessToken.count).to eq 1
            expect(Doorkeeper::AccessToken.first.application_id).to eq client_application.id

            expect(json['access_token'].size).to eq 64
            expect(json['refresh_token']).to eq nil
            expect(json['token_type']).to eq 'bearer'
            expect(json['expires_in']).to eq 7200
            expect(json['created_at'].present?).to eq true
            expect(response.status).to eq 200
          end
        end
      end

      context 'when credentials are not valid' do
        it 'returns error' do
          post '/oauth/token', params: {
            'grant_type' => 'password',
            'email' => 'invalid@example.com',
            'password' => 'invalid'
          }

          expect(json).to eq(
            'error' => 'invalid_grant',
            'error_description' => 'The provided authorization grant is invalid, expired, revoked, does not match ' \
              'the redirection URI used in the authorization request, or was issued to another client.'
          )
          expect(response.status).to eq 401
        end
      end
    end

    describe 'grant_type client_credentials' do
      let(:client_application) { create :client_application }

      context 'with valid params' do
        it 'returns token' do
          post '/oauth/token', params: {
            'grant_type' => 'client_credentials',
            'client_id' => client_application.uid,
            'client_secret' => client_application.secret
          }

          expect(Doorkeeper::AccessToken.count).to eq 1
          expect(Doorkeeper::AccessToken.first.application_id).to eq client_application.id

          expect(json['access_token'].size).to eq 64
          expect(json['refresh_token']).to eq nil
          expect(json['token_type']).to eq 'bearer'
          expect(json['expires_in']).to eq 7200
          expect(json['created_at'].present?).to eq true
          expect(response.status).to eq 200
        end
      end

      context 'with invalid params' do
        it 'returns error' do
          post '/oauth/token', params: {
            'grant_type' => 'client_credentials',
            'client_id' => client_application.uid,
            'client_secret' => "invalid"
          }

          expect(json).to eq(
            'error' => 'invalid_client',
            'error_description' => 'Client authentication failed due to unknown client, ' \
                                   'no client authentication included, or unsupported authentication method.'
          )
          expect(response.status).to eq 401
        end
      end
    end
  end
end
