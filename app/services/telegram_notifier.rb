require "json"
require "net/http"

class TelegramNotifier
  API_BASE_URL = "https://api.telegram.org".freeze
  REQUEST_TIMEOUT = 5

  def initialize(bot_token: ENV["TELEGRAM_BOT_TOKEN"], chat_id: ENV["TELEGRAM_CHAT_ID"], logger: Rails.logger)
    @bot_token = bot_token
    @chat_id = chat_id
    @logger = logger
  end

  def notify_new_inquiry(inquiry)
    unless configured?
      logger.warn("Telegram notification skipped: TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID is not configured")
      return false
    end

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: REQUEST_TIMEOUT, read_timeout: REQUEST_TIMEOUT) do |http|
      http.request(build_request(inquiry))
    end

    return true if response.is_a?(Net::HTTPSuccess)

    logger.error("Telegram notification failed: #{response.code} #{response.body}")
    false
  rescue StandardError => e
    logger.error("Telegram notification error: #{e.class}: #{e.message}")
    false
  end

  private

  attr_reader :bot_token, :chat_id, :logger

  def configured?
    bot_token.present? && chat_id.present?
  end

  def uri
    @uri ||= URI("#{API_BASE_URL}/bot#{bot_token}/sendMessage")
  end

  def build_request(inquiry)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = {
      chat_id: chat_id,
      text: message_for(inquiry)
    }.to_json
    request
  end

  def message_for(inquiry)
    [
      "New service request",
      "ID: #{inquiry.id}",
      "Name: #{inquiry.name}",
      "Phone: #{inquiry.phone}",
      "Service Type: #{inquiry.inquiry_type.presence || 'Not specified'}",
      "Issue: #{inquiry.comment.presence || 'No issue details provided'}"
    ].join("\n")
  end
end
