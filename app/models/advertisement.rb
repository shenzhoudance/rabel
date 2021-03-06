class Advertisement < ApplicationRecord
  validates :link, :banner, :title, :words, :start_date, :expire_date, :duration, :presence => true
  validates :duration, :numericality => {:only_integer => true, :less_than => 3650, :greater_than => 1}

  mount_uploader :banner, AdBannerUploader
  before_validation :set_expire_date

  def self.available
    available_condition.order('start_date DESC').all
  end

  def self.available_condition
    today = Time.zone.today
    where(["start_date <= ? AND expire_date >= ?", today, today])
  end

  def showing?
    today = Time.zone.today
    today >= self.start_date and today <= self.expire_date
  end

  private

  def set_expire_date
    if self.start_date.present? and self.duration.present?
      self.expire_date = self.start_date + self.duration.days
    end
  end
end
