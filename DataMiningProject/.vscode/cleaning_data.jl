using XLSX
using DataFrames

xlsx_file_path = "output.xlsx"
data = DataFrame(XLSX.readtable(xlsx_file_path, "Sheet1"))

# Boş veri içeren satırları temizle
data = dropmissing(data)

data.Format .= replace.(data.Format, "İnternet dizisi" => "Dijital")
data.Format .= replace.(data.Format, "İnternet film serisi" => "Dijital")
data.Format .= replace.(data.Format, "Televizyon filmi" => "TV")
data.Format .= replace.(data.Format, "Doğaçlama;;skeçler" => "TV")
data.Format .= replace.(data.Format, "Televizyon programı" => "TV")
data.Format .= replace.(data.Format, "Televizyon dizisi;;programı" => "TV")
data.Format .= replace.(data.Format, "Televizyon film serisi" => "TV")
data.Format .= replace.(data.Format, "Televizyon dizisi" => "TV")
data.Format .= replace.(data.Format, "TV;;Dijital" => "TV-Dijital")
data.Format .= replace.(data.Format, "Televizyon Dizisi" => "TV")


selected_columns = [:AD, :Format, :Tür, :Senarist, :Yönetmen, :Başrol, :Ülke, :Dili, :Sezonsayısı, :Bölümsayısı, :Yapımcı, :Gösterimsüresi, :Yapımşirketi, :Kanal, :Yayıntarihi, :Durumu]
subset_data = select(data, selected_columns)

XLSX.writetable("cleaning_data.xlsx", DataFrame(subset_data))
