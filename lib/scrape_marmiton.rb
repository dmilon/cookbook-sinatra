require 'nokogiri'
require 'open-uri'

class ScrapeMarmiton
  def self.call(keyword)
    url = "http://www.marmiton.org/recettes/recherche.aspx?aqt=#{keyword}"
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    result = []
    html_doc.search('.recipe-card').each do |element|
      recipe = {}
      element.search('.recipe-card__title').each { |e| recipe[:name] = e.text.strip }
      element.search('.recipe-card__description').each { |e| recipe[:description] = e.text.strip }
      element.search('.recipe-card__duration__value').each { |e| recipe[:prep_time] = e.text.strip }
      recipe_url = "http://www.marmiton.org" + element.attribute('href').value
      recipe[:difficulty] = find_difficulty(recipe_url)
      result << recipe
    end
    result.slice(0, 5)
  end

  private_class_method

  def self.find_difficulty(url)
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)
    html_doc.search('.recipe-infos__level .recipe-infos__item-title').each do |element|
      return element.text.strip
    end
  end
end
