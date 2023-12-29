import Pkg 

using XLSX

using  HTTP

using Gumbo

using DataFrames

using Cascadia

using CSV



#dosya açıldı ve urller okundu
file = open("urlList", "r")
file_content = read(file, String)
urls = split(file_content,"\n")
pop!(urls)


global infoboxes = DataFrame(
    AD =[], 
    Format=[],
    Tür=[],
    Senarist=[], 
    Yönetmen=[], 
    Başrol=[],
    Ülke=[], 
    Dili=[], 
    Sezonsayısı =[], 
    Bölümsayısı=[], 
    Yapımcı=[], 
    Gösterimsüresi=[], 
    Yapımşirketi=[],
    Kanal=[],
    Yayıntarihi=[], 
    Durumu=[],
    #DiğerUlkelerGosterim=[],
)

infobox = DataFrame(
    AD =[], 
    Format=[],
    Tür=[],
    Senarist=[], 
    Yönetmen=[], 
    Başrol=[],
    Ülke=[], 
    Dili=[], 
    Sezonsayısı =[], 
    Bölümsayısı=[], 
    Yapımcı=[], 
    Gösterimsüresi=[], 
    Yapımşirketi=[],
    Kanal=[],
    Yayıntarihi=[], 
    Durumu=[],
    #DiğerUlkelerGosterim=[],
)


seperator = ";;"
"""
url= "https://tr.wikipedia.org/wiki/K%C3%BC%C3%A7%C3%BCk_A%C4%9Fa_(dizi,_1984)";
response = HTTP.get(url)
parsed_html = parsehtml(String(response.body))
body = parsed_html.root[2]

trows   = eachmatch(Selector("table.infobox tr"), parsed_html.root)
trow = trows[20]
labelText = eachmatch(Selector("th"), trow)[1][1].text #direkt th elemanı ve texti
data = eachmatch(Selector("td"), trow)[1] #td alındı

for child in children(data)
    # sadece text tipindeki çocukları al
    if typeof(child) == HTMLText
        # boşlukları temizle ve isimleri listeye ekle
        println(child)
    end
end
"""



function getFormat(td)
    result=""
    data = td
    aTags = eachmatch(Selector("a"), data)
    for aTag in aTags 
        result = result*aTag[1].text*seperator
    end
    return result
end

function getTur(td)
    result=""
    aTags = eachmatch(Selector("a"), td)
    for aTag in aTags 
        result = result*aTag[1].text*seperator
    end
    return result
end

function getSenarist(td)         #a lı veya a sız veriyi alabiliyor aynı zamanda gereksiz a lı tagleri siliyor heryerde kullanılarbilir
    result=""
    aTags = eachmatch(Selector("a"), td)
    temp=[]
    #gerelsiz atag ayrıştırımı
    for atag in aTags
        try
            
            getattr(atag,"title")
            push!(temp, atag)
        catch e
            #demekki gereksiz
            #deleteat!(aTags,i)

        end
    end
    aTags = temp
    if (length(aTags)==0)
        for child in children(td)
            # sadece text tipindeki çocukları al
            if typeof(child) == HTMLText
                # boşlukları temizle ve isimleri listeye ekle
                result = result*child.text*seperator
                
            end
        end
    end
    for aTag in aTags 
        result = result*aTag[1].text*seperator
    end
    return result
end 

function getBolumSayısı(td)
    result=""
    for child in children(td)
        # sadece text tipindeki çocukları al
        if typeof(child) == HTMLText
            # boşlukları temizle ve isimleri listeye ekle
            result = result*child.text
            break
            
        end
    end
    if endswith(result, "(")
        result = chop(result, tail=2)
    end
    return result
end
getSezonSayısı(td) = getBolumSayısı(td);


function getGosterimSuresi(td)
    result=""
    for child in children(td)
        # sadece text tipindeki çocukları al
        if typeof(child) == HTMLText
            # boşlukları temizle ve isimleri listeye ekle
            result = result*child.text
            break
            
        end
    end
    if endswith(result, "dakika")
        result = chop(result, tail=7)
    end
    return result

end

function getKanal(td)
    result=""
    aTags = eachmatch(Selector("a"), td)
    temp=[]
    #gerelsiz atag ayrıştırımı
    for atag in aTags
        try
            
            getattr(atag,"title")
            push!(temp, atag)
        catch e
            #demekki gereksiz
            #deleteat!(aTags,i)

        end
    end
    aTags = temp
    if (length(aTags)==0)
        for child in children(td)
            # sadece text tipindeki çocukları al
            if typeof(child) == HTMLText
                # boşlukları temizle ve isimleri listeye ekle
                result = result*child.text*seperator
                
            end
        end
    end
    for aTag in aTags 
        if(aTag[1].text =="HD")
            continue
        end
        result = result*aTag[1].text*seperator
    end
    return result
end

function  getYayınTarihi(td) #html text ve span data-sort-value içeren spanların.textini alcan
    result=""
    childs = children(td)
    for child in childs
        
        if typeof(child) == HTMLText
            # boşlukları temizle ve isimleri listeye ekle
            result = result*child.text
            
        elseif typeof(child) == HTMLElement{:span}
            
            
            data_sort_value = get(child.attributes, "data-sort-value", nothing)
            if data_sort_value !== nothing
                result = result*child[1].text
            end
            
              
        end
    end
    
    return result
    
end


function generalizedFuncForData(td)
    result=""
    aTags = eachmatch(Selector("a"), td)
    temp=[]
    #gerelsiz atag ayrıştırımı
    for atag in aTags
        try
            
            getattr(atag,"title")
            push!(temp, atag)
        catch e
            #demekki gereksiz
            #deleteat!(aTags,i)

        end
    end
    aTags = temp
    if (length(aTags)==0)
        for child in children(td)
            # sadece text tipindeki çocukları al
            if typeof(child) == HTMLText
                # boşlukları temizle ve isimleri listeye ekle
                result = result*child.text*seperator
                
            end
        end
    end
    for aTag in aTags 
        result = result*aTag[1].text*seperator
    end
    return result
end 




for url in urls
    global infoboxes
    allowmissing!(infobox)
    push!(infobox, fill(missing, ncol(infobox)))

    response = HTTP.get(url)
    parsed_html = parsehtml(String(response.body))
    body = parsed_html.root[2]
    try
        Ad = eachmatch(Selector(".firstHeading i"), parsed_html.root)
        Ad = Ad[1][1].text
        infobox[1, Symbol("AD")] =Ad
    catch e
        empty!(infobox)
        continue
    end
    
    infobox[1, Symbol("Ülke")] ="Türkiye"
    infobox[1, Symbol("Dili")] ="Türkçe"

    #bilgi kutusunda işlem yapmaya başlayalım
    trows   = eachmatch(Selector("table.infobox tr"), parsed_html.root)
    for trow in trows
        
        try
            labelText = eachmatch(Selector("th"), trow)[1][1].text #direkt th elemanı ve texti
            if startswith(labelText,"Format")
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = getFormat(data)
                infobox[1, Symbol("Format")] =result
            elseif startswith(labelText,"Tür")
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = getTur(data)
                infobox[1, Symbol("Tür")] =result
            elseif startswith(labelText,"Senarist")  #veya yazarrrr!!!
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = getSenarist(data)
                infobox[1, Symbol("Senarist")] =result
            elseif startswith(labelText,"Yönetmen")  #  
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = generalizedFuncForData(data)
                infobox[1, Symbol("Yönetmen")] =result
            elseif startswith(labelText,"Başrol")   
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = generalizedFuncForData(data)
                infobox[1, Symbol("Başrol")] =result
            elseif startswith(labelText,"Sezon sayısı")   
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = getSezonSayısı(data)
                infobox[1, Symbol("Sezonsayısı")] =result
            elseif startswith(labelText,"Bölüm sayısı") 
                data = eachmatch(Selector("td"), trow)[1] #td alındı
                result = getBolumSayısı(data) 
                infobox[1, Symbol("Bölümsayısı")] =result
            elseif startswith(labelText,"Yapımcı")    
                data = eachmatch(Selector("td"), trow)[1] #td alındı 
                result = generalizedFuncForData(data)
                infobox[1, Symbol("Yapımcı")] =result
            elseif startswith(labelText,"Gösterim süresi")    
                data = eachmatch(Selector("td"), trow)[1] #td alındı 
                result = getGosterimSuresi(data)
                infobox[1, Symbol("Gösterimsüresi")] =result
            elseif startswith(labelText,"Yapım ")     #veya Dağıtımcı firma ??????????? Fatma (dizi) Leyla_ile_Mecnun_(dizi)? farklı "yapım " span şirketi 
                data = eachmatch(Selector("td"), trow)[1] #td alındı 
                result = generalizedFuncForData(data)
                infobox[1, Symbol("Yapımşirketi")] =result
            elseif startswith(labelText,"Kanal")  || startswith(labelText,"Platform")
                data = eachmatch(Selector("td"), trow)[1] #td alındı 
                result = generalizedFuncForData(data)
                infobox[1, Symbol("Kanal")] =result
            elseif startswith(labelText,"Yayın tarihi") 
                data = eachmatch(Selector("td"), trow)[1] #td alındı 
                result = getYayınTarihi(data)
                infobox[1, Symbol("Yayıntarihi")] =result
            elseif startswith(labelText,"Durumu") 
                data = eachmatch(Selector("td"), trow)[1] #td alındı 
                result = data[1].text
                infobox[1, Symbol("Durumu")] =result
            end
            
        catch e
            #bazı trowların th değerleri yok onlar hataya burda düşüyor
        end
        
    end

    infoboxes=  vcat(infoboxes, infobox)
    empty!(infobox)
end

println(infoboxes)



#CSV.write("output.xlsx", infoboxes)
using ExcelFiles
#infoboxes |> save("output.xlsx")
#save("output.xlsx",infoboxes)



to_string(x::AbstractString) = String(x)
to_string(x::Any) = x
XLSX.writetable("output.xlsx", to_string.(infoboxes))



