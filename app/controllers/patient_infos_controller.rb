class PatientInfosController < ApplicationController
  
  def index
    @patient_infos = PatientInfo.all
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @patient_info = @patient.patient_infos.create(patient_infos)
    
    respond_to do |format|
      if @patient_info.save
        format.html { redirect_to @patient, notice: 'Patient Information was successfully added.' }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { redirect_to @patient, notice: 'Patient Information was not added.' }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @patient = Patient.find(params[:patient_id])
    @patient.patient_infos.where(_id: params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to @patient, notice: 'Patient Information was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def patient_infos
      params.require(:patient_info).permit(:type, :date, :value)
    end

end
