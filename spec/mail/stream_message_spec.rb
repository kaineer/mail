require "spec_helper"
require "stringio"

describe Mail::StreamMessage do
  context ".ctor" do
    it "should be created successfully" do
      expect { described_class.new }.not_to raise_error
    end
  end

  context "#encoded" do
    context "when simple string used" do
      let(:mail) {
        Mail::StreamMessage.new do |mail|
          mail.body = "hello, StreamMessage"
        end
      }

      it "should return a StringContainer instance" do
        expect(mail.encoded).to be_a(::StringContainer)
      end

      it "should include message from stream" do
        expect(mail.encoded.value).to include("hello, StreamMessage")
      end
    end

    context "when stream content used" do
      let(:mail) {
        Mail::StreamMessage.new do |mail|
          mail.body = StringIO.new("hello, StreamMessage")
        end
      }

      it "should include message from stream" do
        expect(mail.encoded.value).to include("hello, StreamMessage")
      end
    end

    context "when stream content contains \\n, \\0 and \\t" do
      let(:mail) {
        Mail::StreamMessage.new do |mail|
          mail.body = StringIO.new("hello,\nStreamMessage\t\0")
        end
      }

      it "should not update binary content" do
        expect(mail.encoded.value).to include("hello,\nStreamMessage\t\0")
      end
    end
  end
end
