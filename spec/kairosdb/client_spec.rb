require 'spec_helper'
require 'support/shared_examples/for_client_http'
require 'support/shared_examples/for_logging'
require 'support/shared_examples/for_query_core'

describe KairosDB::Client do
  subject { KairosDB::Client.new(opts) }
  let(:opts) { Hash.new }

  include_examples 'for_client_http'
  include_examples 'for_logging'
  include_examples 'for_query_core' do
    let(:opts) { Hash.new }
  end

  describe '.new' do
    context 'with no parameters specified' do
      specify { expect(subject.config).to be }
    end
  end
end
