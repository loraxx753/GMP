
require "net/imap"

#Logs a user in and reads the email for a specific user
class EmailReader
	def initialize()
		@messages = Array.new
	end

	# Populates the messages array from the inbox of a given user
	def get_inbox()
		Dir.foreach('./emails') do |item|
			next if item == '.' or item == '..'
				email = File.read("./emails/"+item)
				parsed_email = parse_message(email)
			end
	end

	# Parses a single message into a header, the plain text, and the html
	def parse_message(message_text)

		# This part makes me feel bad... So it's manually checking to see if it's multipart/alternative, and
		# if it's not it assumes it's html/text and deals with it accordingly.
		# This part can definitely be improved.
		if !Regexp.new("Content-Type: multipart/alternative;").match(message_text)
			header_text, html = message_text.split(/<html>/) # It can either be \r\n OR the last instance uses a trailing --
			html = "<html>"+html
			plain = nil
		else
			# Figure out the key that they used to denote the actual email (looks like )
			key = message_text.scan(/--([a-zA-Z0-9\-]+)/)

			# Use that to break up the meta, plain text, and html version of the email
			header_text, plain, html = message_text.split(Regexp.new("--"+Regexp.escape(key[0][0])+'(?:\n.*|--)')) # It can either be \r\n OR the last instance uses a trailing --
		end

		header = self.parse_header(header_text)

		return Array.new(header, plain, html)
	end

	def parse_header(header)
		# Split the head up between key : value
		head_array = header.split(/(?:\n|^)([a-zA-Z\-]*?): /)

		# But that gives us ["\nkey", "value" ""], oh no!
		
		# Strip out the \r\n from the array
		head_array.map! {|x| x.strip}

		# And we should probably get rid of any of the empty elements as well
		head_array.reject! { |c| c.empty? }

		# turn the [key, value] pairs into {key => value} like a good boy
		return Hash[*head_array]
	end

	attr_accessor :messages
end