using XLSX
using DataFrames


xlsx_file_path = "cleaning_data3.xlsx"
infoboxes = DataFrame(XLSX.readtable(xlsx_file_path, "Sheet1"))
"""
xlsx_file_path = "output3.xlsx"
excelInf = XLSX.readtable(xlsx_file_path,"Sheet1"; header = true)
infoboxes = DataFrame(excelInf...)
"""
allBasrolPlayers=String[];
allBasrolPlayersSet = Set(allBasrolPlayers)

allTürs = String[]
allTürsSet = Set(allTürs)

allSenarists = String[]
allSenaristsSet = Set(allSenarists)

allYönetmens =String[]
allYönetmensSet = Set(allYönetmens)

allYapımcıs = String[] 
allYapımcısSet = Set(allYapımcıs)

allYapımŞirketis = String[] 
allYapımŞirketisSet = Set(allYapımŞirketis)

allKanals = String[] 
allKanalsSet = Set(allKanals)

allFormats =  String[] 
allFormatsSet = Set(allFormats)


#infoboxes = dropmissing(infoboxes)

function matchTwoArray(smallElements,bigElements)
    tempVec= fill(0, length(bigElements))
    for i in 1:length(bigElements)
        bigElement = bigElements[i]
        if bigElement in smallElements
            #current index=1
            tempVec[i]=1
        end
    end
    return tempVec
end

#veri toplama
for infobox in eachrow(infoboxes)
    
    basrols = infobox.Başrol
    basrols = split(basrols,";;")
    pop!(basrols) # son elemanı sil
    union!(allBasrolPlayersSet,basrols)   

    türs = infobox.Tür
    türs = split(türs,";;")
    pop!(türs)
    union!(allTürsSet,türs)
    
    senarists = infobox.Senarist
    senarists = split(senarists,";;")
    pop!(senarists)
    union!(allSenaristsSet,senarists)
    
    
    yönetmens = infobox.Yönetmen
    yönetmens = split(yönetmens,";;")
    pop!(yönetmens)
    union!(allYönetmensSet,yönetmens)


    yapımcıs = infobox.Yapımcı
    yapımcıs = split(yapımcıs,";;")
    pop!(yapımcıs)
    union!(allYapımcısSet,yapımcıs)


    yapımŞirketis = infobox.Yapımşirketi
    yapımŞirketis = split(yapımŞirketis,";;")
    pop!(yapımŞirketis)
    union!(allYapımŞirketisSet,yapımŞirketis)


    kanals = infobox.Kanal
    kanals = split(kanals,";;")
    pop!(kanals)
    union!(allKanalsSet,kanals)

    formats = infobox.Format
    formats = split(formats,";;")
    pop!(formats)
    union!(allFormatsSet,formats)

     
end




allBasrolPlayers=collect(allBasrolPlayersSet)
allTürs=collect(allTürsSet)
allSenarists=collect(allSenaristsSet)
allYönetmens=collect(allYönetmensSet)
allYapımcıs=collect(allYapımcısSet)
allYapımŞirketis=collect(allYapımŞirketisSet)
allKanals=collect(allKanalsSet)
allFormats=collect(allFormatsSet)




for infobox in eachrow(infoboxes)
    
    basrols = infobox.Başrol
    basrols = split(basrols,";;")
    pop!(basrols) # son elemanı sil
    result =matchTwoArray(basrols,allBasrolPlayers)
    infobox.Başrol = result

    türs = infobox.Tür
    türs = split(türs,";;")
    pop!(türs)
    result =matchTwoArray(türs,allTürs)
    infobox.Tür = result

    senarists = infobox.Senarist
    senarists = split(senarists,";;")
    pop!(senarists)
    result =matchTwoArray(senarists,allSenarists)
    infobox.Senarist=result

    yönetmens = infobox.Yönetmen
    yönetmens = split(yönetmens,";;")
    pop!(yönetmens)
    result =matchTwoArray(yönetmens,allYönetmens)
    infobox.Yönetmen = result

    yapımcıs = infobox.Yapımcı
    yapımcıs = split(yapımcıs,";;")
    pop!(yapımcıs)
    result =matchTwoArray(yapımcıs,allYapımcıs)
    infobox.Yapımcı = result

    yapımŞirketis = infobox.Yapımşirketi
    yapımŞirketis = split(yapımŞirketis,";;")
    pop!(yapımŞirketis)
    result =matchTwoArray(yapımŞirketis,allYapımŞirketis)
    infobox.Yapımşirketi= result


    kanals = infobox.Kanal
    kanals = split(kanals,";;")
    pop!(kanals)
    result =matchTwoArray(kanals,allKanals)
    infobox.Kanal=result


    formats = infobox.Format
    formats = split(formats,";;")
    pop!(formats)
    result =matchTwoArray(formats,allFormats)
    infobox.Format=result
   
end









