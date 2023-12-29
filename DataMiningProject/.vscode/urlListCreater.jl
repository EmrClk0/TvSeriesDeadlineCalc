
import Pkg

#Pkg.add("DataFrames")
#Pkg.add("HTTP")
#Pkg.add("Gumbo")
#Pkg.add("Cascadia")



baseURL = "https://tr.wikipedia.org"

#GET html
using  HTTP
tvShowsUrl = baseURL*"/wiki/T%C3%BCrk_dizileri_listesi"
response = HTTP.get(tvShowsUrl)

#PARSE HTTML
using Gumbo
parsed_html = parsehtml(String(response.body))
body = parsed_html.root[2]



#her yıkl aralğı için bir table class="wikitable"
#table içinde 2 gereksiz + showların trowları
#her trowun içinde ilk td a tagine sahip
#detaylı verisi  olmayanlar href attribute'u &action=edit&redlink=1 ile bitmekte

#class selector using Cascadia
using Cascadia
tables = eachmatch(Selector(".wikitable"), body)
file = open("urlList","w")



for table in tables
    trows = eachmatch(Selector("tr"), table)
    trows = trows[3:end]
    for trow in trows
        aTag = trow[1][1]
        #println(aTag)
        try
            link = getattr(aTag, "href")
            #println(link)
            if(!endswith(link,"redlink=1"))
                println(file,baseURL*link)
            end
        catch e
            #println("burada bir href ataması yapılmamıs")
        end
    end
end






