class Article < ApplicationRecord
	belongs_to :category
	belongs_to :user

	validates :category, :presence => true
	validates :user, :presence => true
end
