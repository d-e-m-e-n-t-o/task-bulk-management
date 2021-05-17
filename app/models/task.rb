class Task < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, uniqueness: true
  validates :task_status, presence: true
  validates :progress, presence: true
  validates :start, presence: true
  validates :end, presence: true

  attr_accessor :date_range

  def all_day_event?
    self.start == self.start.midnight && self.end == self.end.midnight ? true : false
  end
end
