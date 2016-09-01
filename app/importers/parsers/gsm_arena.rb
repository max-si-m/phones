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
    @@page = @@agent.click(@@page.link_with(text: /#{brand}/i))
    models = []
    path = "//div[contains(@id, 'review-body')]/div/ul/li/a"
    for_each_page do
      models << @@page.search(path).map(&:text)
    end
    models.flatten
  end

  def phone_data(phone)

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
