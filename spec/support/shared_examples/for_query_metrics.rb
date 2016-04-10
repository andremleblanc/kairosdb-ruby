RSpec.shared_examples 'for_query_metrics' do
  describe '#delete_metric' do
    let(:metric_name) { 'test_metric' }

    it 'makes a successful DELETE request to the correct endpoint' do
      stub_request(:delete, "http://localhost:8080/api/v1/metric/#{metric_name}")
      expect(subject.delete_metric(metric_name)).to be_a Net::HTTPOK
    end
  end
end
