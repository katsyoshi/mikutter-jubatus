require 'jubatus/classifier/client'
require 'jubatus/classifier/types'

require 'yaml'

class JubaMikutter
  attr_reader :jubatus
  FAVORITE='favorite'
  TWEET='tweet'
  def initialize(config)
    conf = read_config(config)
    @jubatus = set_client(conf)
  end

  def set_client(conf)
    return Jubatus::Classifier::Client::Classifier.new(conf["host"],conf["port"].to_i)
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
    str = []
    num = []
    str = [data[:str_key], data[:str_data]] if data[:str_key] && data[:str_data]
    num = [data[:num_key], data[:num_data]] if data[:num_key] && data[:num_data]
    datum = Jubatus::Classifier::Datum.new([str],num)
    return datum
  end

  def train(jubatus, data, name='a')
    return jubatus.train(name, data)
  end

  def classify(jubatus,data, name='a')
    return jubatus.classify(name, data)
  end

  def save(jubatus, name='a')
    return jubatus.save(name, '')
  end
end
