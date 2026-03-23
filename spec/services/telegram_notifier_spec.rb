require "rails_helper"

RSpec.describe TelegramNotifier do
  let(:inquiry) do
    Inquiry.create!(
      name: "Alex Johnson",
      phone: "+353 87 123 4567",
      inquiry_type: "Diagnostics",
      comment: "Engine light is on."
    )
  end

  describe "#notify_new_inquiry" do
    it "returns false when telegram is not configured" do
      notifier = described_class.new(bot_token: nil, chat_id: nil)

      expect(notifier.notify_new_inquiry(inquiry)).to be(false)
    end

    it "posts the inquiry to the telegram bot api" do
      notifier = described_class.new(bot_token: "bot-token", chat_id: "chat-id", logger: Logger.new(nil))
      response = instance_double(Net::HTTPSuccess)
      request_capture = nil

      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(Net::HTTP).to receive(:start) do |_host, _port, use_ssl:, open_timeout:, read_timeout:, &block|
        expect(use_ssl).to be(true)
        expect(open_timeout).to eq(5)
        expect(read_timeout).to eq(5)
        http = double("http")
        allow(http).to receive(:request) do |request|
          request_capture = request
          response
        end
        block.call(http)
      end

      expect(notifier.notify_new_inquiry(inquiry)).to be(true)
      expect(request_capture["Content-Type"]).to eq("application/json")

      payload = JSON.parse(request_capture.body)
      expect(payload["chat_id"]).to eq("chat-id")
      expect(payload["text"]).to include("New service request")
      expect(payload["text"]).to include("Alex Johnson")
    end
  end
end
