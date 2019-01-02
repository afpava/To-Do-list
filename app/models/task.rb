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

  def self.uncompleted_tasks_count
    Task.where(completed: [nil, false]).size
  end

  def self.total_tasks_count
    Task.all.size
  end

  # def uncompleted_tasks
  #   self.tasks_uncompleted.size
  # end

  def self.tasks_uncompleted
    Task.where(completed: [nil, false])
  end

  def self.tasks_completed
    Task.where(completed: true)
  end

end
