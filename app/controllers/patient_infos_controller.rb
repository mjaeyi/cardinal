class PatientInfosController < ApplicationController
  def index
    @patient_infos = PatientInfo.all
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @patient_info = @patient.patient_infos.create(patient_infos)
    redirect_to @patient, :notice => "Patient Information Added."
  end

  private
    def patient_infos
      params.require(:patient_info).permit(:type, :date, :value)
    end

end
