# frozen_string_literal: true

require 'spec_helper'

include PullRequestBuilder

RSpec.describe ObsPullRequestPackage, :vcr do
  let(:fake_pull_request) do
    ::OpenStruct.new(number: 1, head: { sha: '6dcb09b5b57875f334f61aebed695e2e4193db5e' },
                     merge_commit_sha: 'e5bd3914e2e596debea16f433f57875b5b90bcd6')
  end

  describe '.obs_project_name' do
    let(:obs_pull_request_package) do
      described_class.new(pull_request: fake_pull_request, obs_package_name: 'obs-server', obs_project_name_prefix: 'Foo:Bar')
    end

    it { expect(obs_pull_request_package.obs_project_name).to eq('Foo:Bar-1') }
  end

  describe '.url' do
    let(:obs_pull_request_package) do
      described_class.new(pull_request: fake_pull_request, obs_package_name: 'obs-server', obs_project_name_prefix: 'Foo:Bar')
    end
    it { expect(obs_pull_request_package.url).to eq('https://build.opensuse.org/package/show/Foo:Bar-1/obs-server') }
  end

  describe '.osc_meta' do
    let(:obs_pull_request_package) do
      described_class.new(pull_request: fake_pull_request, obs_package_name: 'obs-server')
    end
    let(:tempfile) { ::Tempfile.new('foo') }
    before do
      allow_any_instance_of(described_class).to receive(:obs_project_name).and_return('foo')
    end

    context 'pkg' do
      it { expect(obs_pull_request_package.send(:osc_meta, tempfile, :pkg)).to be_a(String) }
    end

    context 'prj' do
      it { expect(obs_pull_request_package.send(:osc_meta, tempfile, :prj)).to be_a(String) }
    end

    context 'non-existent operation' do
      it { expect { obs_pull_request_package.send(:osc_meta, tempfile, :nope) }.to raise_error(ArgumentError) }
    end
  end
end