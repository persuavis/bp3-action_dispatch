# frozen_string_literal: true

require 'rspec'
require 'byebug'

# rubocop:disable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
RSpec.describe 'Bp3::ActionDispatch::RequestLocale' do
  module Bp3
    module ActionDispatch
      class TestClass
        include Bp3::ActionDispatch::RequestLocale

        attr_accessor :original_fullpath, :env, :params, :host, :request_site

        def initialize(host: 'example.com', original_fullpath: '', params: {}, env: {}, request_site: nil)
          @original_fullpath = original_fullpath
          @params = params
          @host = host
          @env = env
          @request_site = request_site
        end

        def locale
          extract_locale
        end
      end
    end
  end

  before do
    I18n.default_locale = :en
    I18n.available_locales = %i[en en-US nl]
  end

  let(:default_locale) { I18n.default_locale }
  let(:test_class) { Bp3::ActionDispatch::TestClass }

  describe '#extract_locale' do
    it 'returns the default locale by default' do
      ['', '/', '//'].each do |path|
        request = test_class.new(original_fullpath: path)
        expect(request.locale).to eq(default_locale)
        expect(request.locale_from).to eq('default')
      end
    end

    it 'returns the locale from the path' do
      ['en', '/en', '/en/', 'en/something', '/en/something', 'en/something/', '/en/something/',
       '//en///something/'].each do |path|
        request = test_class.new(original_fullpath: path)
        expect(request.locale).to eq(:en)
        expect(request.locale_from).to eq('path')
      end
    end

    it 'recognizes the region from the path' do
      ['en-us', '/en-us', '/en-US/', '/en-us/something', '//en-us//something'].each do |path|
        request = test_class.new(original_fullpath: path)
        expect(request.locale).to eq(:'en-US')
        expect(request.locale_from).to eq('path')
      end
    end

    it 'returns the locale from the params' do
      ['', '/', 'something', '/something', 'something/'].each do |path|
        request = test_class.new(original_fullpath: path, params: { locale: 'en' })
        expect(request.locale).to eq(:en)
        expect(request.locale_from).to eq('params')
      end
    end

    it 'recognizes the region from the params' do
      ['', '/', 'something', '/something', 'something/'].each do |path|
        request = test_class.new(original_fullpath: path, params: { locale: 'en-us' })
        expect(request.locale).to eq(:'en-US')
        expect(request.locale_from).to eq('params')
      end
    end

    it 'returns the locale from the host' do
      ['', '/', 'something', '/something', 'something/'].each do |path|
        request = test_class.new(original_fullpath: path, host: 'example.co.en')
        expect(request.locale).to eq(:en)
        expect(request.locale_from).to eq('host')
      end
    end

    it 'recognizes the region from the host' do
      ['', '/', 'something', '/something', 'something/'].each do |path|
        request = test_class.new(original_fullpath: path, host: 'example.co.en-us')
        expect(request.locale).to eq(:'en-US')
        expect(request.locale_from).to eq('host')
      end
    end

    it 'returns the locale from the header' do
      ['', '/', 'something', '/something', 'something/'].each do |path|
        request = test_class.new(original_fullpath: path, env: { 'HTTP_ACCEPT_LANGUAGE' => 'en' })
        expect(request.locale).to eq(:en)
        expect(request.locale_from).to eq('header')
      end
    end

    it 'recognizes the region from the header' do
      ['', '/', 'something', '/something', 'something/'].each do |path|
        request = test_class.new(original_fullpath: path, env: { 'HTTP_ACCEPT_LANGUAGE' => 'en;q=0.1,en-us' })
        expect(request.locale).to eq(:'en-US')
        expect(request.locale_from).to eq('header')
      end
    end
  end
end
# rubocop:enable Lint/ConstantDefinitionInBlock, RSpec/LeakyConstantDeclaration
