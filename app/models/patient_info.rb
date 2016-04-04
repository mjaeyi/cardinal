class PatientInfo
  include Mongoid::Document
  field :type, type: String
  field :date, type: Integer
  field :value, type: Integer

  belongs_to :patient, class_name: "Patient"
end
