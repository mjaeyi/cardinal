class PatientInfo
  include Mongoid::Document

  field :type, type: String
  field :date, type: Integer
  field :value

  belongs_to :patient, class_name: "Patient"

  validates_presence_of :date
end
