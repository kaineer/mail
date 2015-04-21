#

require "string_container"

module Mail
  #
  class StreamMessage < Message
    #
    def body=(*args)
      @body = args
    end

    attr_reader :body

    #
    def encoded
      ready_to_send!

      ::StringContainer.new(
        header.encoded, "\r\n",
        *body)
    end

    private

    # Encodes the message, calls encode on all its parts, gets an email message
    # ready to send
    def ready_to_send!
      identify_and_set_transfer_encoding
      add_required_fields
    end

    def identify_and_set_transfer_encoding
      self.content_transfer_encoding = "binary"
    end

    def add_required_fields
      add_required_message_fields
    end

  end
end
