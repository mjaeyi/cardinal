class PatientInfo
  include Mongoid::Document

  before_save :date_process

  def date_process
    exdate = Date.new(1900, 01, 01)
    entryDate = patient_infos
    entry = Date.parse(entryDate[:date])
    entryDate[:date] = (entry - exdate).to_i
  end


  field :type, type: String
  field :date, type: Integer
  field :value, type: Integer

  belongs_to :patient, class_name: "Patient"

  validates_presence_of :date
end
