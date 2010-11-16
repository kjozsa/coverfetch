#!/usr/bin/ruby
 
require 'rubygems'
require 'net/http'
require 'cgi'
require 'xmlsimple'
 
$amazon_key = "12DR2PGAQT303YTEWP02" # NOT MY KEY (FOUND ON INTERNET)
$amazon_host = "webservices.amazon.com"
 
def fetch_cover(artist, album)
  artist = CGI.escape(artist)
  album = CGI.escape(album)
 
  path = "/onca/xml?Service=AWSECommerceService&AWSAccessKeyId=#{$amazon_key}&Operation=ItemSearch&SearchIndex=Music&Artist=#{artist}&ResponseGroup=Images&Keywords=#{album}"
  data = Net::HTTP.get($amazon_host, path)
  xml = XmlSimple.xml_in(data)
  if xml['Items'][0]['TotalResults'].to_s.to_i then
    cover = {
      :small => xml['Items'][0]['Item'][0]['SmallImage'][0]['URL'],
      :medium => xml['Items'][0]['Item'][0]['MediumImage'][0]['URL'],
      :big => xml['Items'][0]['Item'][0]['LargeImage'][0]['URL']
    }
    return cover
  end
  return nil
end

p fetch_cover('Nickelback', 'Dark Horse')
