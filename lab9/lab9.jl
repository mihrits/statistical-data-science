# Moorits Mihkel Muru, University of Tartu 2022
# Lab 9 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using GLM             # General linear models
using StatsPlots      # Plotting
using CategoricalArrays # Transform continuous array into categorical
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading RData files
using CSV             # Reading CSV files
using Dates           # Standard library for working with datetime formats

# Reading the data from web
students_dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/students.RData"
request = HTTP.get(students_dataset_url)
buffer = CodecZlib.GzipDecompressorStream(IOBuffer(request.body))
students = DataFrame(RData.load(Stream{format"RData"}(buffer))["students"])

# Refactor the gender to 0 - female, 1 - male
students.gender2 = students.gender .- 1

# Test if everything is okay
freqtable(students.gender, students.gender2)

# Find the odds of picking a male students with a logistic model
m1 = glm(@formula(gender2 ~ 1), students, Binomial())
# Test if it is the same result as with simple ratio
student_ratio = sum(students.gender .== 2)/sum(students.gender .== 1)
m1_odds_ratio = m1 |> coef |> only |> exp
@assert isapprox(student_ratio, m1_odds_ratio )

# Probability of meeting a male student in th medical faculty
p1 = m1_odds_ratio/(1+m1_odds_ratio)
@assert isapprox(p1, mean(students.gender2))

# Estimate students gender based on beer consumption
m2 = glm(@formula(gender2 ~ beer), students, Binomial())

# Add height
m3 = glm(@formula(gender2 ~ beer + height), students, Binomial())
m4 = glm(@formula(gender2 ~ beer + height + height^2), students, Binomial())

# Prognosis
prognosis1 = predict(m3) .> 0.155
freqtable(prognosis1, students.gender2)

prognosis2 = predict(m3) .> 0.5
freqtable(prognosis2, students.gender2)
prop(freqtable(prognosis2, students.gender2), margins=2)

# New sample of 100 male and 100 female students
nrs = 1:size(students, 1)
male_sample = sample(nrs[students.gender2 .== 1], 100)
female_sample = sample(nrs[students.gender2 .== 0], 100)
sample2 = students[vcat(male_sample, female_sample), :]

m5 = glm(@formula(gender2 ~ beer + height), sample2, Binomial())
predict(m3, DataFrame(beer = [" 0"], height = [177]))
predict(m5, DataFrame(beer = [" 0"], height = [177]))

m1a = glm(@formula(gender2 ~ 1), sample2, Binomial())

first(predict(m1))
first(predict(m1a))