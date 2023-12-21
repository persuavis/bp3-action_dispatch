# frozen_string_literal: true

# RequestLocale is included in ActionDispatch::Request. It has major similarities with
# the Localization concern, but is subtly different, due to the nature of the classes they are
# embedded in.
# TODO: perhaps refactor Localization and RequestLocale. Or move into middelware?
module RequestLocale
  def request_locale
    @request_locale ||= extract_locale
  end

  private

  def extract_locale
    extract_locale_from_path ||
      extract_locale_from_params ||
      extract_locale_from_host ||
      extract_locale_from_header ||
      extract_locale_from_setting
  end

  def extract_locale_from_path
    locale = original_fullpath.split('/')[original_fullpath.starts_with?('/') ? 1 : 0]
    locale = locale_if_exists(locale)
    @locale_from = 'path' if locale
    locale
  end

  def extract_locale_from_params
    return nil if params[:locale].blank?

    locale = params[:locale]
    locale = locale_if_exists(locale)
    @locale_from = 'params' if locale
    locale
  end

  def extract_locale_from_host
    locale = locale_if_exists(host.split('.').last)
    @locale_from = 'host' if locale
    locale
  end

  # rubocop:disable Metrics/AbcSize
  def extract_locale_from_header
    header = env['HTTP_ACCEPT_LANGUAGE']
    return if header.blank?

    languages = parse_header(header)
    sorted = languages.sort_by { |_l, q| q }.reverse
    locales = sorted.map(&:first)
    symbolized = locales.map { |l| locale_to_sym(l) }
    available = symbolized.select { |l| I18n.available_locales.include?(l) }
    locale = available.first
    @locale_from = 'header' if locale
    locale
  end
  # rubocop:enable Metrics/AbcSize

  def extract_locale_from_setting
    return if request_site&.config.nil?

    locale = locale_if_exists(request_site.configs.locale.presence)
    @locale_from = 'setting' if locale
    locale
  end

  # example format: 'en;q=0.1,nl'
  def parse_header(header)
    languages = header.split(',').map(&:strip)
    languages.map do |language|
      locale, quality = language.split(/\s*;\s*q\s*=\s*/i)
      quality = quality.blank? ? 1.0 : quality.to_f
      [locale, quality]
    end
  end

  def locale_if_exists(locale)
    locale = locale_to_sym(locale)
    I18n.available_locales.include?(locale) ? locale : nil
  end

  def locale_to_sym(locale)
    return nil if locale.nil?
    return locale.to_sym if locale.length == 2

    locale, region = locale.split('-')
    return locale.to_sym if region.nil?

    :"#{locale}-#{region.upcase}"
  end
end
