require 'spec_helper'

FakeResponse = Struct.new(:status, :body)
FakeRequest = Struct.new(:url, :headers)

describe PDC::ResponseError do
  describe '#response' do
    it 'must be passed and can be retrieved' do
      response = FakeResponse.new
      error = PDC::ResponseError.new(response: response)
      error.response.must_equal response
    end
  end

  describe '#status' do
    it 'has an error status' do
      response = FakeResponse.new(200)
      error = PDC::ResponseError.new(response: response)
      error.status.must_equal response.status
    end
  end
end

describe PDC::JsonError do
  describe '#message' do
    describe 'response.body is json' do
      let(:detail) { 'No Authentication token' }
      let(:body_with_detail) { { 'detail' => detail } }
      let(:body_without_detail) { { 'foo' => 'bar', 'bar' => 'baz' } }

      it 'must return detail if present' do
        status = 404
        response = FakeResponse.new(status, body_with_detail.to_json)
        error = PDC::JsonError.new(response: response)
        error.message.must_equal "Error: #{status} - #{detail}"
      end

      it 'must return body if detail is absent' do
        status = 404
        response = FakeResponse.new(status, body_without_detail.to_json)
        error = PDC::JsonError.new(response: response)

        error.message.must_equal "Error: #{status} - #{body_without_detail.to_json}"
      end
    end

    describe 'response.body is not json parsable' do
      let(:invalid_json) { '<html><head></head><body></body></html>' }
      let(:status) { 404 }
      let(:response) { FakeResponse.new(status, '<html><head></head><body></body></html>') }

      it 'must return body' do
        error = PDC::JsonError.new(response: response)
        error.message.must_equal "Error: #{status} - #{response.body}"
      end
    end
  end
end
