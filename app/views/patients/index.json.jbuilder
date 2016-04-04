json.array!(@patients) do |patient|
  json.extract! patient, :id, :_id, :age, :plot, :score
  json.url patient_url(patient, format: :json)
end
