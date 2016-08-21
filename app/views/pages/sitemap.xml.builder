base_url = "http://#{request.host_with_port}"
xml.instruct! :xml, :version=>'1.0'

xml.urlset(xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9") do
  xml.url do
    xml.loc "#{base_url}"
    xml.lastmod Time.now.to_date
    xml.changefreq "weekly"
    xml.priority 1.0
  end
  xml.url do
    xml.loc "#{base_url}/index"
    xml.lastmod Time.now.to_date
    xml.changefreq "weekly"
    xml.priority 1.0
  end
  xml.url do
    xml.loc "#{base_url}/privacy_policy"
    xml.lastmod Time.now.to_date
    xml.changefreq "weekly"
    xml.priority 1.0
  end
  xml.url do
    xml.loc "#{base_url}/terms_of_service"
    xml.lastmod Time.now.to_date
    xml.changefreq "weekly"
    xml.priority 1.0
  end
end