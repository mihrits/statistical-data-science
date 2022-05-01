# Moorits Mihkel Muru, University of Tartu 2022
# Lab 11 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using GLM             # General linear models
using MultivariateStats # For PCA
using Clustering      # Clustering methods
using Chain           # Piping functions
using StatsPlots      # Plotting
# Load data from web
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files

# Reading the data from web
function get_data(url)
    @chain url begin
        HTTP.get
        IOBuffer(_.body)
        CodecZlib.GzipDecompressorStream
        Stream{format"RData"}(_)
        RData.load
        values
        only
    end
end

dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/world.RData"
world_full = get_data(dataset_url)

# Julia doesn't have rownames, so I have to import them manually
rownames = """Albania
Angola
Argentina
Armenia
Australia
Austria
Bahamas
Bahrain
Bangladesh
Barbados
Belarus
Belgium
Belize
Benin
Bhutan
Bolivia
Bosnia and Herzegovina
Botswana
Brazil
Bulgaria
Burkina Faso
Burundi
Canada
Chile
China
Colombia
Comoros
Costa Rica
Croatia
Cuba
Cyprus
Denmark
Ecuador
El Salvador
Eritrea
Estonia
Ethiopia
Fiji
Finland
France
Georgia
Germany
Ghana
Greece
Guatemala
Guinea-Bissau
Guyana
Honduras
Hungary
Iceland
Indonesia
Iran
Ireland
Israel
Italy
Japan
Jordan
Kazakhstan
Kenya
Kiribati
Kuwait
Latvia
Liberia
Libya
Lithuania
Luxembourg
Malawi
Mali
Malta
Mauritius
Mexico
Moldova
Mongolia
Morocco
Mozambique
Namibia
Nepal
Netherlands
New Zealand
Nicaragua
Nigeria
Norway
Oman
Pakistan
Panama
Papua New Guinea
Paraguay
Peru
Philippines
Poland
Qatar
Russia
Rwanda
Senegal
Serbia
Seychelles
Sierra Leone
Singapore
Slovenia
South Africa
Spain
Sri Lanka
Sudan
Sweden
Switzerland
Syria
Tajikistan
Tanzania
Togo
Trinidad and Tobago
Tunisia
Turkey
Turkmenistan
Uganda
Ukraine
United Arab Emirates
United Kingdom
United States
Venezuela
Vietnam
Zambia
Zimbabwe"""

world_full.names = split(rownames, '\n')

world_clean = dropmissing(world_full)
world_clean.lgdp = log.(world_clean.gdp)
world_mod = select(world_clean, Not(:gdp))

for colname in names(world_mod)
    colname == "names" && continue
    colmax = maximum(world_mod[!, colname])
    world_mod[!,colname] /= colmax
end

# Reordering columns
select!(world_mod, :names, Not(:names))

world_scaled_num = Matrix(select(world_mod, Not(:names)))

kmeans3 = kmeans(world_scaled_num', 3)

totcosts = []
for k in 1:20
    currtotcosts = []
    for _ in 1:1000
        push!(currtotcosts, kmeans(world_scaled_num', k).totalcost)
    end
    push!(totcosts, mean(currtotcosts))
end
let
    plot(1:20, totcosts)
    scatter!(1:20, totcosts)
end

km6 = kmeans(world_scaled_num', 6)

world_mod.cluster = assignments(km6)

# Note to self, shoudl not have added names and clusters to world_mod.
# It makes it more annoying to extract the names of observables.

# Distance matrix with Distance.jl