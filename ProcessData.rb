require 'csv'

p_modifiers = [231, 222, 221, 212, 211, 202, 201, 192, 191, 182, 181, 172]
s_modifiers = {
  nil => 0.5,
  "4" => 1,
  "2" => 0.75,
  "3" => 0.75
}
q_modifiers = {
  nil => 0.5,
  "3" => 0.75,
  "4" => 0.75
}
city_modifiers = {
  nil => 0.5,
  "678" => 1
}
skills_modifiers = {
  "1080" => 0.125,
  "1081" => 0.125,
  "1070" => 0.125,
  "264" => 0.125,
}

(p_modifiers + [0]).reverse.each do |p_modifier|
  modifiers_sum = 0
  pct10_sum, pct25_sum, pct50_sum, pct75_sum, pct90_sum = 0, 0, 0, 0, 0
  CSV.foreach('salaries.csv', :headers => true) do |row|
    unless row["pct10"] == "0" && row["pct25"] == "0" && row["pct50"] == "0" && row["pct75"] == "0" && row["pct90"] == "0" || row["p"] != p_modifier.to_s
      modifier = 1.0
      if row["p"] != "0"
        modifier /= 2 ** p_modifiers.find_index(row["p"].to_i)
      else
        modifier /= 2 ** (p_modifiers.length / 2.0)
      end
      modifier *= s_modifiers[row["s"]]
      modifier *= q_modifiers[row["q"]]
      modifier *= city_modifiers[row["city"]]
      modifier *= (0.5 +
        skills_modifiers[row["skill1"]].to_i +
        skills_modifiers[row["skill2"]].to_i +
        skills_modifiers[row["skill3"]].to_i)
      modifiers_sum += modifier
      pct10_sum += row["pct10"].to_i * modifier
      pct25_sum += row["pct25"].to_i * modifier
      pct50_sum += row["pct50"].to_i * modifier
      pct75_sum += row["pct75"].to_i * modifier
      pct90_sum += row["pct90"].to_i * modifier
    end
  end

  print([p_modifier, ": ", (pct10_sum / modifiers_sum).round,
         (pct25_sum / modifiers_sum).round,
         (pct50_sum / modifiers_sum).round,
         (pct75_sum / modifiers_sum).round,
         (pct90_sum / modifiers_sum).round], "\n")
end

modifiers_sum = 0
pct10_sum, pct25_sum, pct50_sum, pct75_sum, pct90_sum = 0, 0, 0, 0, 0

CSV.foreach('salaries.csv', :headers => true) do |row|
  unless row["pct10"] == "0" && row["pct25"] == "0" && row["pct50"] == "0" && row["pct75"] == "0" && row["pct90"] == "0"
    modifier = 1.0
    if row["p"] != "0"
      modifier /= 2 ** p_modifiers.find_index(row["p"].to_i)
    else
      modifier /= 2 ** (p_modifiers.length / 2.0)
    end
    modifier *= s_modifiers[row["s"]]
    modifier *= q_modifiers[row["q"]]
    modifier *= city_modifiers[row["city"]]
    modifier *= (0.5 +
      skills_modifiers[row["skill1"]].to_i +
      skills_modifiers[row["skill2"]].to_i +
      skills_modifiers[row["skill3"]].to_i)
    modifiers_sum += modifier
    pct10_sum += row["pct10"].to_i * modifier
    pct25_sum += row["pct25"].to_i * modifier
    pct50_sum += row["pct50"].to_i * modifier
    pct75_sum += row["pct75"].to_i * modifier
    pct90_sum += row["pct90"].to_i * modifier
  end
end

print(["current", ": ", (pct10_sum / modifiers_sum).round,
       (pct25_sum / modifiers_sum).round,
       (pct50_sum / modifiers_sum).round,
       (pct75_sum / modifiers_sum).round,
       (pct90_sum / modifiers_sum).round], "\n")