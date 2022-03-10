# Moorits Mihkel Muru, University of Tartu 2022
# Lab 4 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using GLM             # Linear models / regression
using StatsPlots      # Plotting
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files

# Reading the data from web
students_dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/students.RData"
request = HTTP.get(students_dataset_url)
buffer = CodecZlib.GzipDecompressorStream(IOBuffer(request.body))
students = DataFrame(RData.load(Stream{format"RData"}(buffer))["students"])

# Linear modelling
model1 = lm(@formula(SVR ~ height), students)
students_heightSVR = dropmissing(students, [:height, :SVR])
@df students_heightSVR scatter(:height, :SVR)
@df students_heightSVR plot!(:height, predict(model1))

# Multidimensional linear model
model2 = lm(@formula(SVR ~ height + weight + (gender==2)), students)

model3 = lm(@formula(SVR ~ weight), students)

corrmat = cor(Matrix(dropmissing(students[!, [:weight, :height, :SVR, :DVR]])))
@df dropmissing(students[!, [:weight, :height, :SVR, :DVR]]) corrplot(cols(1:4))
@df dropmissing(students[!, [:weight, :height, :SVR, :DVR]]) cornerplot(cols(1:4), compact=true)