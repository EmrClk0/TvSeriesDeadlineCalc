using XLSX
using DataFrames
using Random



xlsx_file_path = "cleaning_data.xlsx"
infoboxes = DataFrame(XLSX.readtable(xlsx_file_path, "Sheet1")...)
"""
xlsx_file_path = "cleaning_data.xlsx"
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




global data = DataFrame(
    AD =String[], 
    Format=Vector{Int}[],
    Tür=Vector{Int}[],
    Senarist=Vector{Int}[], 
    Yönetmen=Vector{Int}[], 
    Başrol=Vector{Int}[],
    Ülke=String[], 
    Dili=String[], 
    Sezonsayısı =Int[], 
    Bölümsayısı=Int[], 
    Yapımcı=Vector{Int}[], 
    Gösterimsüresi=Int[], 
    Yapımşirketi=Vector{Int}[],
    Kanal=Vector{Int}[],
    YayınBaslangıc=Int[], 
    YayınBitis=Int[],
    Durumu=String[],
    #DiğerUlkelerGosterim=[],
)

temp = DataFrame(
    AD =String[], 
    Format=Vector{Int}[],
    Tür=Vector{Int}[],
    Senarist=Vector{Int}[], 
    Yönetmen=Vector{Int}[], 
    Başrol=Vector{Int}[],
    Ülke=String[], 
    Dili=String[], 
    Sezonsayısı =Int[], 
    Bölümsayısı=Int[], 
    Yapımcı=Vector{Int}[], 
    Gösterimsüresi=Int[], 
    Yapımşirketi=Vector{Int}[],
    Kanal=Vector{Int}[],
    YayınBaslangıc=Int[], 
    YayınBitis=Int[],
    Durumu=String[],
    #DiğerUlkelerGosterim=[],
)

for infobox in eachrow(infoboxes)
    global data
    allowmissing!(temp)
    push!(temp, fill(missing, ncol(temp)))

    try
        temp[1, Symbol("AD")] = string.(infobox.AD)
        temp[1, Symbol("Format")] = infobox.Format
        temp[1, Symbol("Tür")] = infobox.Tür
        temp[1, Symbol("Senarist")] = infobox.Senarist
        temp[1, Symbol("Yönetmen")] = infobox.Yönetmen
        temp[1, Symbol("Başrol")] = infobox.Başrol
        temp[1, Symbol("Ülke")] = infobox.Ülke
        temp[1, Symbol("Dili")] = infobox.Dili
        temp[1, Symbol("Sezonsayısı")] = parse(Int, infobox.Sezonsayısı)
        temp[1, Symbol("Bölümsayısı")] =parse(Int,  infobox.Bölümsayısı)
        temp[1, Symbol("Yapımcı")] = infobox.Yapımcı
        temp[1, Symbol("Gösterimsüresi")] = parse(Int,  infobox.Gösterimsüresi)
        temp[1, Symbol("Yapımşirketi")] = infobox.Yapımşirketi
        temp[1, Symbol("Kanal")] = infobox.Kanal
        temp[1, Symbol("YayınBaslangıc")] = infobox.YayınBaslangıc
        temp[1, Symbol("YayınBitis")] = infobox.YayınBaslangıc
        temp[1, Symbol("YayınBitis")] = infobox.YayınBitis
        temp[1, Symbol("Durumu")] = string.(infobox.Durumu)
        
    catch e
            println("some error")
            empty!(temp)
            continue

    end


    data=  vcat(data, temp)
    empty!(temp)
end

dropmissing!(data)



features  = [:Format, :Tür, :Senarist, :Yönetmen, :Başrol, :Yapımcı, :Yapımşirketi, :Kanal, :YayınBaslangıc]
target = :Durumu
#subset_data = select(data, selected_columns)

function create_training_data(data, train_fraction)
    n_samples = Int(round(size(data, 1) * train_fraction))
    
    shuffled_data = shuffle(data)
    training_data = shuffled_data[1:n_samples, :]
    
    return training_data
end

function create_training_data_without_test_data(full_data, test_data)
    condition_to_keep(row) = !(row in eachrow(test_data))
    training_data = filter(row -> condition_to_keep(row), full_data)
    return training_data
end

function split_data(df, train_fraction)
    n = nrow(df)
    indices = randperm(n)
    train_size = Int(round(train_fraction * n))
    train_indices = indices[1:train_size]
    test_indices = indices[train_size+1:end]
    return df[train_indices, :], df[test_indices, :]
end

train_fraction = 0.1

#test_datas = create_training_data(data, train_fraction)
#train_datas = create_training_data_without_test_data(data, test_datas)
test_datas,train_datas = split_data(data, train_fraction)

#TEST_dATADA VE TRAİN DATADAN BÖLÜM SAYISI SEZON SAYISI YAYINBİTİŞ DURUMU
select!(train_datas, Not([:"Bölümsayısı",:"YayınBitis",:"Durumu"]))
select!(test_datas, Not([:"Bölümsayısı",:"YayınBitis",:"Durumu"]))

#select!(test_datas, Not([:"Sezonsayısı"]))
test_data_sezonsayısı = test_datas[:, "Sezonsayısı"]
select!(test_datas, Not([:"Sezonsayısı"]))

"""
testData = eachrow(test_datas)[1]
baslangıcTarihi = testData.YayınBaslangıc

condition_to_keep(row) = row.YayınBaslangıc < baslangıcTarihi 
filtered_trainData = filter(row -> condition_to_keep(row), train_datas)

Xtrain_datas = filtered_trainData[!, :1 :end]
Ytrain_datas = filtered_trainData[:,:Sezonsayısı]
realSezonSayısı = testData.Sezonsayısı
select!(Xtrain_datas, Not([:"Sezonsayısı"]))
select!(testData, Not([:"Sezonsayısı"]))
using DecisionTree
model = DecisionTreeClassifier(max_depth=5)
DecisionTree.fit!(model, Matrix(Xtrain_datas), Ytrain_datas)
predictions = DecisionTree.predict(model, Matrix(DataFrame(testData))) #SEZON SAYISI TAHMİN EDİLDİ
if predictions[1] == realSezonSayısı
    print("başarılı ")
    println(predictions)
else
    println("hatalı tahmin gerçek değer")
    println(predictions)

end


"""


predicted_Values = Int[]
for i in 1:length(eachrow(test_datas))
    testData=eachrow(test_datas)[i]

    baslangıcTarihi = testData.YayınBaslangıc
    condition_to_keep(row) = row.YayınBaslangıc < baslangıcTarihi 
    filtered_trainData = filter(row -> condition_to_keep(row), train_datas)

    Xtrain_datas = filtered_trainData[!, :1 :end]
    Ytrain_datas = filtered_trainData[:,:Sezonsayısı]
    realSezonSayısı = test_data_sezonsayısı[i]

    select!(Xtrain_datas, Not([:"Sezonsayısı"]))
    

    using DecisionTree
    model = DecisionTreeClassifier(max_depth=100)
    DecisionTree.fit!(model, Matrix(Xtrain_datas), Ytrain_datas)
    predictions = DecisionTree.predict(model, Matrix(DataFrame(testData))) #SEZON SAYISI TAHMİN EDİLDİ
    print(testData.AD)
    println(predictions)
    print("gerçek data ")
    println(realSezonSayısı)
    push!(predicted_Values,predictions[1])
    """
    if predictions[1] == realSezonSayısı
        print("başarılı ")
        println(predictions)
    else
        println("hatalı tahmin gerçek değer")
        println(predictions)

    end"""
end


max1= maximum(test_data_sezonsayısı)
max2 = maximum(predicted_Values)

max=max1
if max2>max1
    max=max2
end



using MLBase
using Plots
cm = confusmat(max,test_data_sezonsayısı,predicted_Values)
heatmap(cm, xlabel="Tahmin Edilen", ylabel="Gerçek Değer", title="Confusion Matrix")



