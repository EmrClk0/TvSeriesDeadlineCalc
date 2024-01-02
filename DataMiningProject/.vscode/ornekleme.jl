import Pkg
Pkg.add("Classifier")
using XLSX
using DataFrames
using DecisionTree

xlsx_file_path = "cleaning_data2.xlsx"
data = DataFrame(XLSX.readtable(xlsx_file_path, "Sheet1")...)

features  = [:AD, :Format, :Tür, :Senarist, :Yönetmen, :Başrol, :Ülke, :Dili, :Yapımcı, :Yapımşirketi, :Kanal, :YayınBaslangıc]
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

train_fraction = 0.1
test_datas = create_training_data(data, train_fraction)
train_datas = create_training_data_without_test_data(data, test_datas)
test_datas[!, :Durumu] .= ""
test_datas[!, :YayınBitis] .= ""
test_datas[!, :Bölümsayısı] .= ""
test_datas[!, :Sezonsayısı] .= ""


using DecisionTree
testData = eachrow(test_datas)[1]
baslangıcTarihi = testData.YayınBaslangıc

condition_to_keep(row) = row.YayınBaslangıc < baslangıcTarihi 
filtered_trainData = filter(row -> condition_to_keep(row), train_datas)

model = DecisionTreeClassifier(max_depth=2)
model = DecisionTree.build_tree(filtered_trainData[!, target], Matrix(filtered_trainData[:, features]), max_depth=2)

fit!(model, filtered_trainData, features)

predictions = predict(model, testData)

accuracy = sum(predictions .== testData.Durumu) / size(testData, 1)


"""
for train_data  in eachrow(train_datas)
    baslangıcTarihi = trainData.YayınBaslangıc
    condition_to_keep(row) = row.YayınBaslangıc < baslangıcTarihi 
    filtered_train_data = filter(row -> condition_to_keep(row), train_datas)
end
"""