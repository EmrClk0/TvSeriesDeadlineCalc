using XLSX
using DataFrames

xlsx_file_path = "output.xlsx"
data = DataFrame(XLSX.readtable(xlsx_file_path, "Sheet1"))

# Boş veri içeren satırları temizle
data = dropmissing(data)

data.Format .= replace.(data.Format, "İnternet dizisi" => "Dijital")
data.Format .= replace.(data.Format, "İnternet film serisi" => "Dijital")

selected_columns = [:AD, :Format, :Tür, :Senarist, :Yönetmen, :Başrol, :Ülke, :Dili, :Sezonsayısı, :Bölümsayısı, :Yapımcı, :Gösterimsüresi, :Yapımşirketi, :Kanal, :Yayıntarihi, :Durumu]
subset_data = select(data, selected_columns)

XLSX.writetable("cleaning_data.xlsx", DataFrame(subset_data))
