# frozen_string_literal: true

require 'test_plugin_helper'

module ForemanGitTemplates
  class HostTest < ActiveSupport::TestCase
    describe '#repository_path' do
      context 'with template_url parameter' do
        let(:repo_tempfile) { Tempfile.new }
        let(:repo_path) { repo_tempfile.path }
        let(:host) { FactoryBot.create(:host, :managed, :with_template_url) }

        it 'returns path to the repository' do
          ForemanGitTemplates::RepositoryFetcher.expects(:call).once.with(host.params['template_url']).returns(repo_tempfile)
          assert_equal repo_path, host.repository_path
        end
      end

      context 'without template_url parameter' do
        let(:host) { FactoryBot.create(:host, :managed) }

        it 'returns nil' do
          ForemanGitTemplates::RepositoryFetcher.expects(:call).never
          assert_nil host.repository_path
        end
      end
    end
  end
end
