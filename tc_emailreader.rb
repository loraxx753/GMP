# File:  tc_gmp.rb
 
require "./emailreader.rb"
require "test/unit"
 
class TestEmailReader < Test::Unit::TestCase
	def setup
		@mail = EmailReader.new()
		@test_message
	end

	def test_object
		assert_instance_of( EmailReader, @mail)
	end

	def test_inbox
		@mail.get_inbox
		assert(@mail.messages.count>0, "No messages were added to the messages array!")
	end

	def test_parse_message
		email = ''
		Dir.foreach('./email') do |item|
			next if item == '.' or item == '..'
				email = File.read("./email/"+item)
				break
			end
		@test_message = @mail.parse_message(email)
		assert_instance_of(Hash, @test_message)
	end

	def test_subject
		test_parse_message
		assert_instance_of(String, "#{@test_message['header']['Subject']}")
	end
	def test_to
		test_parse_message
		assert_instance_of(String, "#{@test_message['header']['To']}")
	end
	def test_from
		test_parse_message
		assert_instance_of(String, "#{@test_message['header']['From']}")
	end

	def test_date
		test_parse_message
		assert_instance_of(String, "#{@test_message['header']['Date']}")
	end

	def test_content_type
		test_parse_message
		assert_instance_of(String, "#{@test_message['header']['Content-Type']}")
	end

	def test_html
		test_parse_message
		assert_instance_of(String, "#{@test_message['html']}")
	end

	def test_plaintext
		test_parse_message
		assert_instance_of(String, "#{@test_message['plaintext']}")
	end
 
end