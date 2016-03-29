RSpec.shared_examples 'for_client_http' do
  describe '#get' do
    let(:path) { KairosDB::Query::Core::KAIROSDB_GET_PATH }
    let(:stub_url) { 'http://localhost:8080' + path }
    let(:get_url) { subject.send(:full_path, path) }

    context 'without retry' do
      it 'sends a successful GET to the correct endpoint' do
        stub_request(:get, stub_url)
        expect(subject.get(get_url)).to be nil
      end
    end
  end

  describe '#post' do
    let(:path) { KairosDB::Query::Core::KAIROSDB_POST_PATH }
    let(:stub_url) { 'http://localhost:8080' + path }
    let(:post_url) { subject.send(:full_path, path) }

    context 'without retry' do
      it 'sends a successful GET to the correct endpoint' do
        stub_request(:post, stub_url)
        expect(subject.post(post_url, {})).to be_a Net::HTTPOK
      end
    end

    context 'when retry is 0' do
      let(:opts) { { retry: 0 } }

      it 'raises an error without retrying' do
        stub_request(:post, stub_url).to_timeout

        expect(subject).not_to receive(:sleep)
        expect { subject.post(post_url, {}) }.to raise_error(KairosDB::ConnectionError) do |e|
          expect(e.cause).to be_a Timeout::Error
        end
      end
    end

    context 'when retry is n' do
      let(:opts) { { retry: 3 } }

      it "raises an error after retrying n times" do
        allow(subject).to receive(:log)
        stub_request(:post, stub_url).to_timeout

        expect(subject).to receive(:sleep).exactly(opts[:retry]).times
        expect { subject.post(post_url, {}) }.to raise_error(KairosDB::ConnectionError) do |e|
          expect(e.cause).to be_a Timeout::Error
        end
      end
    end

    context 'when retry is -1' do
      let(:opts) { { retry: -1 } }
      let(:retries_until_success) { 2 }

      it "keeps trying until successful" do
        allow(subject).to receive(:log)
        stub_request(:post, stub_url).to_timeout.times(retries_until_success).then.to_return(status: 200)

        expect(subject).to receive(:sleep).exactly(retries_until_success).times
        expect { subject.post(post_url, {}) }.not_to raise_error
      end
    end
  end
end
