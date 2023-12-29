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
    AD =Array{String, 1}[], 
    Format=Array{String, 1}[],
    Tür=Array{String, 1}[],
    Senarist=Array{String, 1}[], 
    Yönetmen=Array{String, 1}[], 
    Başrol=Array{String, 1}[],
    Ülke=Array{String, 1}[], 
    Dili=Array{String, 1}[], 
    Sezonsayısı =Array{String, 1}[], 
    Bölümsayısı=Array{String, 1}[], 
    Yapımcı=Array{String, 1}[], 
    Gösterimsüresi=Array{String, 1}[], 
    Yapımşirketi=Array{String, 1}[],
    Kanal=Array{String, 1}[],
    Yayıntarihi=Array{String, 1}[], 
    Durumu=Array{String, 1}[],
    #DiğerUlkelerGosterim=Array{String, 1}[],
)

infobox = DataFrame(
        AD =Array{String, 1}[], 
        Format=Array{String, 1}[],
        Tür=Array{String, 1}[],
        Senarist=Array{String, 1}[], 
        Yönetmen=Array{String, 1}[], 
        Başrol=Array{String, 1}[],
        Ülke=Array{String, 1}[], 
        Dili=Array{String, 1}[], 
        Sezonsayısı =Array{String, 1}[], 
        Bölümsayısı=Array{String, 1}[], 
        Yapımcı=Array{String, 1}[], 
        Gösterimsüresi=Array{String, 1}[], 
        Yapımşirketi=Array{String, 1}[],
        Kanal=Array{String, 1}[],
        Yayıntarihi=Array{String, 1}[], 
        Durumu=Array{String, 1}[],
        #DiğerUlkelerGosterim=Array{String, 1}[],
    )


function tdataReturner(td)
    realData=[]
    
    geneltd = td
    genelChilds = children(geneltd)
    length(children(genelChilds[1]))

    if(length(genelChilds)==1)
        i=length(children(genelChilds[1]))
        if(i==0)
            push!(realData,genelChilds[1])
        else
            for child in genelChilds
    
                i = length(children(child))
                if i>0
                push!(realData,child[1])
            
                end
            
            end
        end
    else
        for child in genelChilds
    
            i = length(children(child))
            if i>0
            push!(realData,child[1])
            end

        end
    end
    return realData
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
        advector=[]
        push!(advector,Ad[1][1])
        ad_texts = [string(x) for x in advector]
        ad_array = Vector{String}(ad_texts)
        infobox[1, Symbol("AD")] =ad_array
    catch e

    end
    
    trows   = eachmatch(Selector("table.infobox tr"), parsed_html.root)
    for trow in trows
        try
            label = eachmatch(Selector("th"), trow)
            data = eachmatch(Selector("td"), trow)
            if(length(data)>0) # datası bulunan kısımlar
    
                td = data[1]
                labelText = label[1][1].text
                
                if(labelText=="Platform")
                    labelText= "Kanal"
                end
                if(labelText=="Yapım ")
                    labelText= "Yapım şirketi"
                end
    
                if(labelText!="Ülke")
                    labelText = replace(labelText, " " => "") # Sezon sayısı => Sezonsayısı
                    
                    tdata = tdataReturner(td)
                    plain_texts = [string(x) for x in tdata]
                    string_array = Vector{String}(plain_texts)
                    infobox[1, Symbol(labelText)] =string_array
                    #print(labelText * "   ") 
                    #println(string_array)
                    
                elseif(labelText=="Ülke")
                    infobox[1, Symbol("Ülke")] =["Türkiye"]
                end
                
            end
           
        catch e
            
        end
    
    end

    infoboxes=  vcat(infoboxes, infobox)
    empty!(infobox)
end

#CSV.write("output.xlsx", infoboxes)
using ExcelFiles
#infoboxes |> save("output.xlsx")
save("output.xlsx",infoboxes)
