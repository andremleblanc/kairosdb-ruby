RSpec.shared_examples 'for_logging' do
  describe '.log' do
    it "uses the logging class to write logs" do
      expect(KairosDB::Logging.logger).to receive(:error)
      subject.log(:error, 'Test')
    end
  end
end
