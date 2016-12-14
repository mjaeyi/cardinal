class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]
  before_action :pdf_patient, only: [:plot, :score, :genplot, :genrisk, :risk, :upload]

  # GET /patients
  # GET /patients.json
  def index
    @patients = Patient.all
  end

  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @patient = Patient.new
  end

  # GET /patients/1/edit
  def edit
  end

  def upload
      uploaded_file = params[:cfile]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end

  def genplot
    if @patient.plot.present?
      curtime = Time.new
      system("mv #{@patient.plot} #{@patient.dirpath}/archive/#{@patient._id}_#{curtime.strftime("%Y%m%d%H%M%S")}.pdf")
    end

    system("/data/opensource/PlotGen/ca125_plot_cardinal_v0.1.R #{@patient.dirpath}/#{@patient._id}.pd")
    @patient.update_attributes(:plot => "#{@patient.dirpath}/#{@patient._id}.pdf")
    redirect_to @patient, notice: 'Plot was successfully generated.' 
  end

  def genrisk
    if @patient.risk.present?
      curtime = Time.new
      system("mv #{@patient.risk} #{@patient.dirpath}/archive/#{@patient._id}_risk#{curtime.strftime("%Y%m%d%H%M%S")}.pdf")
    end

    f = File.new("#{@patient.dirpath}/riskdata.csv", 'w')
    @patient.patient_infos.order_by(:date => 'asc').each do |info|
	ptdata = info.date.to_s + "," + info.value.to_s + "," + info.type + "\n"
	f.write(ptdata)
    end
    f.close

    system("/data/opensource/Cardinal/convertForRisk.py #{@patient.dirpath}/riskdata.csv #{@patient.dirpath}/#{@patient._id}.csv")
    system("/data/opensource/Robin/Robin.R #{@patient.dirpath}/#{@patient._id}.csv")
    @patient.update_attributes(:risk => "#{@patient.dirpath}/#{@patient._id}_risk.pdf")
    system("rm #{@patient.dirpath}/riskdata.csv #{@patient.dirpath}/#{@patient._id}.csv")
    redirect_to @patient, notice: 'Risk was successfully generated.'
  end

  def plot
    send_file(@patient.plot, :filename => "plot.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  def score
    send_file(@patient.score, :filename => "score.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  def risk
    send_file(@patient.risk, :filename => "risk.pdf", :disposition => 'inline', :type => "application/pdf")
  end

  # POST /patients
  # POST /patients.json
  def create
    n_patient_params = patient_params
    system("mkdir /data/oci/#{n_patient_params[:_id]}")
    n_patient_params[:dirpath] = "/data/oci/#{n_patient_params[:_id]}"
    system("mkdir #{n_patient_params[:dirpath]}/archive")
    @patient = Patient.new(n_patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    @patient.destroy
    respond_to do |format|
      format.html { redirect_to patients_url, notice: 'Patient was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    def pdf_patient
      @patient = Patient.find(params[:format])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:_id, :age, :plot, :score, :dirpath, :risk, :cfile)
    end
end
