# frozen_string_literal: true

# RequestHost is included in ActionDispatch::Request
module RequestHost
  def normalized_host
    return host if valid_host?(host)
    return forwarded_host if valid_host?(forwarded_host)

    host
  end

  private

  def forwarded_host
    @forwarded_host ||= env['X-Forwarded-Host']
  end

  def valid_host?(host)
    host.present? && !ip_address?(host)
  end

  def ip_address?(host)
    return false if host.blank?
    return true if Resolv::IPv4::Regex.match?(host)
    return true if Resolv::IPv6::Regex.match?(host)

    false
  end
end
