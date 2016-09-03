class Parsers::GsmArena < BaseParser
  def initialize
    super
    @@page = @@agent.get('http://www.gsmarena.com/makers.php3')
  end

  def brands
    @@page.search("//a[span[contains(.,'devices')]]").map do |link|
      link.text[/([a-z\-&.]+)\d/i, 1]
    end
  end

  def models(brand)
    @@models_page = @@agent.click(@@page.link_with(text: /#{brand}/i))
    @@page = @@models_page
    models = []
    path = "//div[contains(@id, 'review-body')]/div/ul/li/a"
    for_each_page do
      models << @@page.search(path).map(&:text)
    end
    models.flatten
  end

  def phone_detail(model)
    @@page = @@models_page
    for_each_page do
      break if @@page = @@agent.click(@@page.link_with(text: model))
    end

    # better make some DataPoint class and describe field on there, but it take
    # more time, for now, array enough
    data_point = @@page.search("//table").each_with_object([]) do |table, data_point|
      header = table.search('.//th').text
      fields = table.search('.//tr').each_with_object({}) do |r, blob|
        data = r.search('.//td')
        title = data.first.try(:text)
        value = data.last.try(:text)
        blob[title] = value
      end
      data_point << { "#{header}": fields }
    end
    data_point << { title: [@@page.title] }
    data_point.reverse
  end

  private

  def for_each_page(&block)
    pages = @@page.search("//div[contains(@class, 'nav-pages')]/a")
    pages_count = pages.empty? ? 1 : pages.last.text.to_i
    pages_count.times do |n|
      yield
      @@page = @@agent.click(@@page.link_with(href: '#1')) if pages_count > 1
    end
  end
end
