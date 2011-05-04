class Document < ActiveRecord::Base
has_and_belongs_to_many :rooms
validates_presence_of   :name,:rhtml
end
