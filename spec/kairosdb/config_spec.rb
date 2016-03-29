require 'spec_helper'

describe KairosDB::Config do
  subject { KairosDB::Config.new(opts) }
  let(:opts) { Hash.new }

  describe '.new' do
    context 'with no parameters specified' do
      specify { expect(subject.host).to eq 'localhost' }
      specify { expect(subject.port).to eq 8080 }
      specify { expect(subject.initial_delay).to eq 0.01 }
      specify { expect(subject.max_delay).to eq 30 }
      specify { expect(subject.open_timeout).to eq 5 }
      specify { expect(subject.read_timeout).to eq 300 }
      specify { expect(subject.retry).to eq 3 }
    end
  end
end
