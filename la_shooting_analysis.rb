#Work with Los Angeles police shooting incident data.
#Souce:  data.lacounty.gov

require 'csv'

la_shooting_data = Array.new

#Open csv file of shooting incidents data.
#Write to a an array.
CSV.foreach("LA_Shooting_Incidents_2010_to_Present.csv", 
headers: true) do |row|
    la_shooting_data.push(row)
end


#Convert data to integers and floats where appropriate.
la_shooting_data.each do |row|
    row["# OF INVOLVED DEPUTIES"] = row["# OF INVOLVED DEPUTIES"].to_i
    row["# OF PERSONS"] = row["# OF PERSONS"].to_i
    row["# OF PERSONS WOUNDED"] = row["# OF PERSONS WOUNDED"].to_i
    row["# OF PERSONS DECEASED"] = row["# OF PERSONS DECEASED"].to_i
    unless row["APPROX_LATITUDE"].nil?
        row["APPROX_LATITUDE"] = row["APPROX_LATITUDE"].to_f
    end
    unless row["APPROX_LONGITUDE"].nil?
        row["APPROX_LONGITUDE"] = row["APPROX_LONGITUDE"].to_f
    end
end


#Column max value function
def find_max(table, colname)
    maxval = -9999
    table.each do |row|
        next unless row[colname] != nil && row[colname] > maxval 
            maxval = row[colname]
    end
    return maxval
end

#Column min value function
def find_min(table, colname)
    minval = 9999
    table.each do |row|
        next unless row[colname] != nil && row[colname] < minval
        minval = row[colname]
    end
    return minval
end

#Function to find average of column
def find_average(table, colname)
    sum = 0
    counter = 0
    table.each do |row|
        next unless row[colname] != nil
            sum = sum + row[colname]
            counter += 1
    end
    sum = sum.to_f
    counter = counter.to_f
    mean = sum/counter
    return mean    
end       

colnames = Array["# OF INVOLVED DEPUTIES", "# OF PERSONS", 
"# OF PERSONS WOUNDED", "# OF PERSONS DECEASED", "APPROX_LATITUDE",
"APPROX_LONGITUDE"]

#Write output to file
f = File.open('LA_shootings_summary.md', 'w')

f.puts "# LA Shooting Incident Data Summary:"

colnames.each do |field|
    col = field
    max_result = find_max(la_shooting_data, col)
    min_result = find_min(la_shooting_data, col)
    avg_result = find_average(la_shooting_data, col)

    f.puts "* MAX " + col + ": " + max_result.to_s 
    f.puts "* MIN " + col + ": " + min_result.to_s
    f.puts "* AVG " + col + ": " + avg_result.to_s 
end

f.close
  
