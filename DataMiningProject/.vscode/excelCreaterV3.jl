import Pkg 
using Dates
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
    YayınBaslangıc=[], 
    YayınBitis=[],
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
    YayınBaslangıc=[], 
    YayınBitis=[],
    Durumu=[],
    #DiğerUlkelerGosterim=[],
)


seperator = ";;"




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
function getMonth(month)
    if month=="Ocak"
        return 1
    elseif  month=="Şubat"
        return 2
    elseif  month=="Mart"
        return 3
    elseif  month=="Nisan"
        return 4
    elseif  month=="Mayıs"
        return 5
    elseif  month=="Haziran"
        return 6
    elseif  month=="Temmuz"
        return 7
    elseif  month=="Ağustos"
        return 8
    elseif  month=="Eylül"
        return 9
    elseif  month=="Ekim"
        return 10
    elseif  month=="Kasım"
        return 11
    elseif  month=="Aralık"
        return 12
    end
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
                yayınTarihleri = split(result,"-")
                başlangıc=nothing;
                bitiş = nothing

                if length(yayınTarihleri)>=1
                    başlangıc = yayınTarihleri[1]
                    başlangıc = strip(başlangıc)
                end
                if length(yayınTarihleri)>=2
                    bitiş = yayınTarihleri[2]
                    bitiş = strip(bitiş)
                end

                if başlangıc!=nothing && başlangıc!=""
                    baslangıcDateArray = split(başlangıc," ")
                    
                    
                    try
                        baslangıcDay = parse(Int, baslangıcDateArray[1])
                        baslangıcMonth = getMonth(baslangıcDateArray[2])
                        baslangıcYear = parse(Int,baslangıcDateArray[3])
                
                        dateObj = Date(baslangıcYear, baslangıcMonth, baslangıcDay)
                        dateObjTimeStamp = Int(floor(datetime2unix(Dates.DateTime(dateObj))))
                        #gerekli yere atama
                        infobox[1, Symbol("YayınBaslangıc")] =dateObjTimeStamp
                       
                    catch e  #1993-2001 örneği
                        baslangıcDay=1
                        baslangıcMonth=1
                        baslangıcYear=parse(Int,baslangıcDateArray[1])
                        dateObj = Date(baslangıcYear, baslangıcMonth, baslangıcDay)
                        dateObjTimeStamp = Int(floor(datetime2unix(Dates.DateTime(dateObj))))
                        #gerekli yere atama
                        infobox[1, Symbol("YayınBaslangıc")] =dateObjTimeStamp
                    
                        
                    end
                   
                end
                
                
                if bitiş!=nothing && bitiş!=""
                
                    if bitiş == "günümüz"
                        atama= Int(floor(datetime2unix(now())))
                        
                        infobox[1, Symbol("YayınBitis")] =atama
                    else
                        try
                            bitişDateArray = split(bitiş," ")
                
                            bitişDay = parse(Int, bitişDateArray[1])
                            bitişMonth = getMonth(bitişDateArray[2])
                            bitişYear = parse(Int,bitişDateArray[3])
                
                            dateObj = Date(bitişYear, bitişMonth, bitişDay)
                            dateObjTimeStamp = Int(floor(datetime2unix(Dates.DateTime(dateObj))))
                            #gerekli yere atama
                            infobox[1, Symbol("YayınBitis")] =dateObjTimeStamp
                        catch e
                            bitişDateArray = split(bitiş," ")
                            bitişYear = parse(Int,bitişDateArray[1])
                            bitişDay=1
                            bitişMonth=1
                
                            dateObj = Date(bitişYear, bitişMonth, bitişDay)
                            dateObjTimeStamp = Int(floor(datetime2unix(Dates.DateTime(dateObj))))
                            #gerekli yere atama
                            infobox[1, Symbol("YayınBitis")] =dateObjTimeStamp
                        
                           
                        end
                        
                
                        
                    end
                end



























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

#println(infoboxes)



#CSV.write("output.xlsx", infoboxes)
using ExcelFiles
#infoboxes |> save("output.xlsx")
#save("output.xlsx",infoboxes)



to_string(x::AbstractString) = String(x)
to_string(x::Any) = x
XLSX.writetable("output.xlsx", to_string.(infoboxes))



