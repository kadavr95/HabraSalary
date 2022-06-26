# CSV.foreach('/tmp/habrasalary.csv', :headers => true) do |row|
#   row["id"]==
# end
# Moscow Softwaredev Fullstack Backend Frontend Junior Middle Ruby Rubyonrails Javascript React
# 1      0.25        1         0.5     0.5      0.5    0.5    0.2  0.3         0.2        0.3
#                                                              \0.5/               \0.5/
# max: 4
#
# by categories average values for the date are average of values with modifiers
# (all*3.5/4+allminusmoscow*2.5/4+moscow*1/4)/(7/4)
# in case of junior and middle (with other categories being the same) => direct average between these values
#
# needed all 5 data points: 10, 25, 50, 75, 90 percentiles
#
# by dates:
# 2022.2 2022.1 2021.2 2021.1 2020.2 2020.1 2019.2 2019.1 2018.2 2018.1 etc
# 1      1/2    1/4    1/8    1/16   1/32   1/64   1/128  1/256  1/512
# these are modifiers for the difference not for the rmss
# https://www.varsitytutors.com/hotmath/hotmath_help/topics/line-of-best-fit
# for the data from all time period - use it as the data point for the average of time range
#
# some measurement of number of answers?
# like additional modifier of number of candidates for current answer divided by overall
#
#
# options_num = 11
# (2 ** options_num).times do |index|
#   puts index.to_s(2).rjust(options_num, "0")
# end