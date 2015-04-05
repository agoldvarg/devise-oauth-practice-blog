class Conversation < ActiveRecord::Base
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'
 
  has_many :messages, dependent: :destroy
 
  # Somehow, this is checking that all conversations are unique. Basically, it doesn't matter
  # who the sender and recipient are - sender_id:1 --> recipient_id:2 is the same conversation
  # as sender_id:2 --> recipient_id:1
  validates_uniqueness_of :sender_id, :scope => :recipient_id
 
  # Like a helper method - active record query for all conversations involving the current user.
  # Again, it doesn't matter if the user is the sender or recipient - only that they're part
  # of a particular conversation.
  scope :involving, -> (user) do
    where("conversations.sender_id =? OR conversations.recipient_id =?",user.id,user.id)
  end
 
  # Another helper query to find out if the sender/recipient are already having a conversation
  # If so, we'll retrieve that conversation instead of creating a new one
  scope :between, -> (sender_id,recipient_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_id =?) OR (conversations.sender_id = ? AND conversations.recipient_id =?)", sender_id,recipient_id, recipient_id, sender_id)
  end
end
