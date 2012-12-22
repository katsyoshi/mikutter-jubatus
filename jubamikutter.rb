require 'jubatus/classifier/client'
require 'jubatus/classifier/types'

require 'json'
require 'yaml'
require 'msgpack'

class JubaMikutter
  attr_reader :jubatus
  def initialize(config)
    conf = read_config(config)
    dirname = File.dirname(File.expand_path(config))
    hoge = dirname+'/'+conf["jubatus"]
    learn = read_config(File.expand_path(hoge))
    @jubatus = Jubatus::Client::Classifier.new(conf["host"],conf["port"].to_i)
    settings = Jubatus::Config_data.new(conf["algo"], learn.to_json)
    @jubatus.set_config(conf['name'], settings)
  end

  def get_most_likely(estimates)
    result = nil
    estimates.map do |est|
      result = est if result.nil? || result[1].to_f < est[1].to_f
    end
    return result
  end

  def read_config(file)
    converter = YAML.load(open(file).read())
    converter.each do |k,v|
      converter[k] = {} if /types$/ =~ k && v.nil?
      converter[k] = [] if /rules$/ =~ k && v.nil?
    end
    return converter
  end

  def set_datum(data={str_key: nil, str_data: nil, num_key: nil, num_data: nil})
    datum = Jubatus::Datum.new([[data[:str_key], data[:str_data]]],[])
    return datum
  end

  def train(jubatus, data, name='a')
    return jubatus.train(name, data)
  end

  def classify(jubatus,data, name='a')
    return jubatus.classify(name, data)
  end
end
