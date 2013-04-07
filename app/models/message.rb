class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :author
  field :content
end
