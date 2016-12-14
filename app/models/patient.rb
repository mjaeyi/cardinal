class Patient
  include Mongoid::Document
  field :_id, type: String
  field :age, type: Integer
  field :dirpath, type: String
  field :plot, type: String
  field :score, type: String
  field :risk, type: String
  field :cfile, type: String

  has_many :patient_infos, class_name: "PatientInfo", :dependent => :delete

  validates_presence_of :_id
  validates_uniqueness_of :_id
end
