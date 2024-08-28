require 'openai'
require 'json'

class ExtractEventInfo
  INSTRUCTIONS = <<~INSTRUCTIONS
    Please extract the details from the event image, including any Japanese text, and translate them into English. The details should include the event's name as name, address, start_date, end_date. Dates should be in (yyyy/mm/dd) format only and be returned in a JSON format without markdown or anything else. Only return the JSON object, without any introduction or explanation.
  INSTRUCTIONS

  def initialize(photo_url)
    @photo_url = photo_url
  end

  def call
    client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])
    messages = [
      { role: "user", content: [
        { type: 'text', text: INSTRUCTIONS },
        { type: "image_url", image_url: { url: @photo_url } }
      ] }
    ]
    puts '-' * 50
    puts "Sending request to OpenAI API to parse the business card..."
    puts '-' * 50

    begin
      response = client.chat(
        parameters: {
          model: "gpt-4o",
          messages: messages,
          max_tokens: 2000
        }
      )

      answer = response.dig("choices", 0, "message", "content")
      JSON.parse(answer)
    rescue JSON::ParserError => e
      puts "Error parsing JSON: #{e.message}"
      nil
    rescue StandardError => e
      puts "An unexpected error occurred: #{e.message}"
      nil
    end
  end
end
