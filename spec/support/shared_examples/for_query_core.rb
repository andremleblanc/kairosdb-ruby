RSpec.shared_examples 'for_query_core' do
  let(:time) { (Time.now.to_f * 1000).to_i }
  let(:measurement_name) { 'widgets' }
  let(:tags) {{ brand: 'ACME', owner: 'Wile E' }}

  describe '#query' do
    let(:widgets) {{ name: measurement_name, tags: tags }}
    let(:metrics) { [widgets] }
    let(:query) {{ start_relative: time, metrics: metrics }}
    let(:stub_path) { subject.send(:full_path, KairosDB::Query::Core::KAIROSDB_GET_PATH, query) }
    let(:stub_url) { 'http://localhost:8080' + stub_path }

    let(:response_tags) {{ 'owner' => [ 'Wile E' ] }}
    let(:response_values) { [[time, 10]] }
    let(:results) {{ 'name' => measurement_name, 'tags' => response_tags, 'values' => response_values }}
    let(:metric) {{ results: results }}
    let(:metrics) { [metric] }
    let(:queries) {{ queries: metrics }}
    let(:response) {{ body: JSON.generate(queries) }}

    let(:error_msg_1) { "metrics[0].aggregate must be one of MIN,SUM,MAX,AVG,DEV" }
    let(:error_msg_2) { "metrics[0].sampling.unit must be one of SECONDS,MINUTES,HOURS,DAYS,WEEKS,YEARS" }
    let(:errors) {{ 'errors' => [error_msg_1, error_msg_2]}}
    let(:error_response) {{ body: JSON.generate(errors), status: 400 }}

    context 'with a single metric' do
      it 'makes a successful GET request to the correct endpoint' do
        stub_request(:get, stub_url).to_return(response)
        expect(subject.query(query)).to eq results
      end
    end

    context 'with a query error' do
      it 'makes an usuccessful GET request to the correct endpoint' do
        stub_request(:get, stub_url).to_return(error_response)
        expect{ subject.query(query)}.to raise_error(KairosDB::QueryError, errors[:errors])
      end
    end
  end

  describe '#write_data' do

    let(:data_points) { [[time, 10]] }
    let(:data) {{ measurement_name: measurement_name, data_points: data_points, tags: tags }}

    context 'with a single data point' do
      it 'makes a successful POST request to the correct endpoint' do
        stub_request(:post, "http://localhost:8080/api/v1/datapoints").
          with(body: data, headers: { 'Content-Type'=>'application/json' })

        expect(subject.write_data(data)).to be_a Net::HTTPOK
      end
    end

    context 'with multiple data points' do
      let(:data_points) { [[time, 10], [time + 1, 10], [time + 2, 10]] }

      it 'makes a successful POST request to the correct endpoint' do
        stub_request(:post, "http://localhost:8080/api/v1/datapoints").
          with(body: data, headers: { 'Content-Type'=>'application/json' })

        expect(subject.write_data(data)).to be_a Net::HTTPOK
      end
    end

    context 'with no tags' do
      let(:tags) { Hash.new }

      it 'makes a successful POST request to the correct endpoint' do
        stub_request(:post, "http://localhost:8080/api/v1/datapoints").
          with(body: data, headers: { 'Content-Type'=>'application/json' })

        expect(subject.write_data(data)).to be_a Net::HTTPOK
      end
    end
  end
end
