require 'csv'
require 'selenium-webdriver'
require 'webdrivers'

CSV.open("salaries.csv", "w") do |csv|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--host-resolver-rules=MAP connect.facebook.net 127.0.0.1')
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for :chrome, options: options

  # report period
  # periods = [0, 172, 181, 182, 191, 192, 201, 202, 211, 212, 221, 222] # all data then detailed in format is YY.halfYear
  periods = [0, 172, 181, 182, 191, 192, 201, 202, 211, 212, 221] # all data then detailed in format is YY.halfYear
  # specialization
  specializations = [nil, 4, 2, 3] # [full-stack, backend, frontend]
  # qualifications
  qualifications = [nil, 3, 4] # [junior, middle]
  # skills
  # three nils are required for the easier iteration over existing combinations
  skills = [nil, nil, nil, 1080, 1081, 1070, 264] # [Ruby on Rails, Ruby, React, JavaScript]
  # city
  city_ids = [nil, 678] # Moscow

  options_to_check = []
  periods.each do |p|
    specializations.each do |s|
      qualifications.each do |q|
        city_ids.each do |city|
          skills.each_with_index do |skill_1, index_1|
            skills[(index_1 + 1)..].each_with_index do |skill_2, index_2|
              skills[(index_1 + index_2 + 2)..].each do |skill_3|
                options_to_check.push({ p: p, s: s, q: q, city: city, skill_1: skill_1, skill_2: skill_2, skill_3: skill_3 })
              end
            end
          end
        end
      end
    end
  end

  headers = %w[pct10 pct25 pct50 pct75 pct90 query p s q city skill1 skill2 skill3]
  csv << headers

  options_to_check.uniq.each do |o|
    query = "https://career.habr.com/salaries?utf8=%E2%9C%93&p=#{o[:p]}"\
        "#{o[:s] ? "&sg=1&s=#{o[:s]}" : ""}&q=#{o[:q]}"\
        "&skills%5B%5D=#{o[:skill_1]}&skills%5B%5D=#{o[:skill_2]}&skills%5B%5D=#{o[:skill_3]}"\
        "&employment_type=&remote=&company_id=#{o[:city] ? "&city_ids%5B%5D=#{o[:city]}" : ""}"
    driver.get query
    elements = driver.find_elements(:css, "body > div.page-container > div > div > div.content-wrapper > div > div.section.salaries > div.body > div.salary_stats > div.img > svg > g > text")
    values = []
    elements.each do |elem|
      if elem.text.include?("k руб.")
        values.push(/(\d+)k руб./.match(elem.text)[1].to_i)
      end
    end
    if values == []
      values = [0, 0, 0, 0, 0]
    end
    values = values.sort.push(query, o[:p], o[:s], o[:q], o[:city], o[:skill_1], o[:skill_2], o[:skill_3])
    puts values.join(",")
    csv << values
  end

  driver.quit
end