load(url("http://www.ms.ut.ee/mart/andmeteadus/tudengid.RData"))

attach(tudengid)

barplot(prop.table(table(sugu, olu),2), legend=T,
        xlim=c(0,7), col=c("red", "gray95"),
        xlab="Mitu pudelit õlut tudeng nädalas joob?",
        ylab="Naistudengite osakaal",
        legend.text=c("naine","mees"))

kaal[c(1,4,24)]

ftable(olu[sugu==2])

tudengid[sugu==1 & pikkus>180,] # Jätab andmestikku alles naised, kes on pikemad kui 180 cm.

tudengid[1:7,]

tudengid[sugu==2 & pikkus<170,]