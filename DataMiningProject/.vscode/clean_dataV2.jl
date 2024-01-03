using XLSX
using DataFrames

function clean_data_and_write(input_file::AbstractString, output_file::AbstractString)
    data = DataFrame(XLSX.readtable(input_file, "Sheet1"))

    data = dropmissing(data)

    format_mapping = Dict(
        "İnternet dizisi" => "Dijital",
        "İnternet film serisi" => "Dijital",
        "Televizyon filmi" => "TV",
        "Doğaçlama;;skeçler" => "TV",
        "Televizyon programı" => "TV",
        "Televizyon dizisi;;programı" => "TV",
        "Televizyon film serisi" => "TV",
        "Televizyon dizisi" => "TV",
        "TV;;Dijital" => "TV-Dijital",
        "Televizyon Dizisi" => "TV",
    )

    durumu_mapping = Dict(
        "Belirsiz" => "Final",
        "Sona erdi " => "Final",
        "Sona erdi." => "Final",
        "Sona erdi" => "Final",
        "Yayından kaldırıldı" => "Final",
        "2.Sezon Çekimleri" => "Devam",
        "Yayında" => "Devam",
        "Sezon arası" => "Devam",
        "Yayımlandı" => "Devam",
        "Ara verdi" => "Devam",
        "Devam ediyor" => "Devam",
    )

    for key in keys(format_mapping)
        data.Format .= replace.(data.Format, key => format_mapping[key])
    end

    for key in keys(durumu_mapping)
        data.Durumu .= replace.(data.Durumu, key => durumu_mapping[key])
    end

    selected_columns = [:AD, :Format, :Tür, :Senarist, :Yönetmen, :Başrol, :Ülke, :Dili, :Sezonsayısı, :Bölümsayısı, :Yapımcı, :Gösterimsüresi, :Yapımşirketi, :Kanal, :Yayıntarihi, :Durumu]
    subset_data = select(data, selected_columns)

    XLSX.writetable(output_file, DataFrame(subset_data))
end

clean_data_and_write("output3.xlsx", "cleaning_data2.xlsx")
