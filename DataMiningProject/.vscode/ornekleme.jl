using XLSX
using DataFrames

# Excel dosyasından veriyi yükle
xlsx_file_path = "output.xlsx"
data = DataFrame(XLSX.readtable(xlsx_file_path, "Sheet1"))

# İlgilenilen sütunları seç
selected_columns = [:Sezonsayısı, :Bölümsayısı, :Gösterimsüresi, :Yayıntarihi, :Durumu]

# Seçilen sütunları içeren bir alt veri seti oluştur
subset_data = select(data, selected_columns)

# Eğitim kümesini oluşturmak için veriyi karıştır ve belirli bir oranda seç
function create_training_data(data, train_fraction)
    n_samples = Int(round(size(data, 1) * train_fraction))
    
    # Veriyi karıştır
    shuffled_data = shuffle(data)
    
    # Eğitim kümesini oluştur
    training_data = shuffled_data[1:n_samples, :]
    
    return training_data
end

# Eğitim kümesini oluştur (örneğin, %80 oranında eğitim kümesi)
train_fraction = 0.1
training_data = create_training_data(subset_data, train_fraction)

# Oluşturulan eğitim kümesini incele
println("Eğitim Kümesi:")
println(training_data)
