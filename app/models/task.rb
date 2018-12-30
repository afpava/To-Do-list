class Task < ApplicationRecord
  belongs_to :user
  validates :title, :presence => true, uniqueness: { scope: :user,
    message: "Title exists!" }
  validates :text, presence: true

  enum priority: [:low, :regular, :top]

  after_initialize do
      if self.new_record?
        self.priority ||= :regular
      end
  end

end
