require 'timecop'

RSpec.describe ContaAzulApi::Authentication do
  describe '.authentication_expired?' do
    before do
      stub_const('CaAuthHistory', FakeCaAuthHistory)

      logger = double(:logger, info: '')
      allow(Rails).to receive(:logger).and_return(logger)
    end

    it 'returns positive when no access token is provided' do
      authentication = ContaAzulApi::Authentication.new

      expect(authentication.authentication_expired?).to be_truthy
    end

    it 'returns positive when access token is expired' do
      ContaAzulApi::Helpers.stub_refresh_token

      authentication = ContaAzulApi::Authentication.new
      authentication.refresh_access_token

      Timecop.freeze(Time.now + 2.hours) do
        expect(authentication.authentication_expired?).to be_truthy
      end
    end

    it 'returns negative when access token is up to date' do
      ContaAzulApi::Helpers.stub_refresh_token

      authentication = ContaAzulApi::Authentication.new
      authentication.refresh_access_token

      expect(authentication.authentication_expired?).to be_falsy
    end
  end
end
