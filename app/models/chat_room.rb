class ChatRoom < ApplicationRecord
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_id, class_name: 'User'

  has_many :messages, dependent: :destroy
  has_many :last_messages, -> { order('created_at DESC').limit(10)  }, class_name: 'Message'

  validates_uniqueness_of :sender_id, :scope => :recipient_id

  def self.involving(user)
    where("sender_id = ? OR recipient_id = ?", user.id, user.id)
  end

  def self.between(sender_id, recipient_id)
    where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)", sender_id, recipient_id, recipient_id, sender_id)
  end
end
