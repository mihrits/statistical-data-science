# Moorits Mihkel Muru, University of Tartu 2022
# Lab 3 of the Statistical Data Science (LTMS.00.025) course
# Solutions in Julia

using DataFrames      # Tables for data
using StatsBase       # Basic statistics tools
using FreqTables      # Frequency tables
using Distributions   # Normal distribution
using HypothesisTests # Hypothesis Testing
using StatsPlots      # Plotting
using HTTP            # Stream data from web
using FileIO          # Reading in a file from a web stream
using CodecZlib       # Unpacking RData file
using RData           # Reading in RData

# Reading the data from web
students_dataset_url = "http://www.ms.ut.ee/mart/andmeteadus/students.RData"
request = HTTP.get(students_dataset_url)
buffer = CodecZlib.GzipDecompressorStream(IOBuffer(request.body))
students = DataFrame(RData.load(Stream{format"RData"}(buffer))["students"])

# Finding the confidence interval for a coin (binomial distribution)
BinomialTest(1,3)          # For summary
confint(BinomialTest(1,3)) # For more accurate confidence interval

# 95% confidence interval for probability of "not guilty" ("hot iron ordeal")
confint(BinomialTest(52,130))
# Same for Tartu county court
confint(BinomialTest(29, 4285))

# Finding the mean of dice throws and the confidence interval for the mean
diceres = [5, 6, 6, 1, 3, 4, 3, 1, 2]
OneSampleTTest(diceres)          # For summary
mean(diceres)                    # For more accurate mean
confint(OneSampleTTest(diceres)) # For more accurate confidence interval

# Clean weights from missing values
stud_weight = collect(skipmissing(students.weight))
# Find mean of the weights and confidence interval
OneSampleTTest(stud_weight)
# Find confidence interval with 99% confidence
confint(OneSampleTTest(stud_weight), level=0.99)

# Sample mean vs population mean
sample_height = sample(students.height, 10) # Sample heights of 10 students
OneSampleTTest(sample_height) # Sample mean height with 95% confidence interval
mean(students.height)         # Population mean height

# Smokers
freqtable(students.smoking)
smokers = map(>=(3), students.smoking) # 0 for non-smokers, 1 for smokers
mask_avail_weights = map(!ismissing, students.weight)
OneSampleTTest(collect(skipmissing(students.weight[smokers])))
OneSampleTTest(collect(skipmissing(students.weight[.~smokers])))

# Plotting weight means and confidence intervals for smokers and non-smokers
function wrangle_data(dataframe, column, mask)
    data = collect(skipmissing(dataframe[mask, column]))
    data_mean = mean(data)
    data_confint = confint(OneSampleTTest(data))
    (
        data = data,
        mean = data_mean,
        confint = data_confint,
        error = data_confint[1] - data_mean
    )
end
weight_smokers = wrangle_data(students, :weight, smokers)
weight_nonsmokers = wrangle_data(students, :weight, .~smokers)

scatter(
    [weight_nonsmokers.mean, weight_smokers.mean],
    yerror = [weight_nonsmokers.error, weight_smokers.error],
    xlim = (0,3), ylabel = "Weights", label = "Mean value",
    xticks = ([1,2], ["Non-smokers", "Smokers"])
)

# confidence intervals for median
SignTest(stud_weight) # confint(..., level=...)

# qqnorm from StatsPlots
qqnorm(stud_weight)

# Poisson function probability density and cumulative distrbution functions
pdf(Poisson(7.5), 15)
cdf(Poisson(7.5), 15)

# For Binomial
pdf(Binomial(60, 1/6), 10)