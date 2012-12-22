# -*- coding: utf-8 -*-
dirname = File.dirname(File.expand_path(__FILE__))
require dirname + '/jubamikutter.rb'

Plugin.create(:jotei2) do
  on_boot do
    @jubamikutter = Jubamikutter.new(dirname+'/learn.conf')
  end

  on_update do |service, message|
    if !message.empty?
      message.map do |msg|
        classify(msg)
      end
    end
  end

  def classify(msg)
    sgs = suggestion(@jubamikutter, msg.to_s)
    STDERR.puts sgs
    if sgs
      msg.favorite(true)
      if UserConfig[:jubatus_train] == true
        data = {str_key: 'message', str_data: msg}
        datum = @jubamikutter.set_datum({str_key: 'message', str_data: msg})
        @jubamikutter.train(@jubamikutter.jubatus, [["favorite", datum]])
      end
    else
      if UserConfig[:jubatus_train] == true
        datum = @jubamikutter.set_datum({str_key: 'message', str_data: msg})
        @jubamikutter.train(@jubamikutter.jubatus, [["tweet",datum]])
      end
    end
  end

  def suggestion(jubatus, msg)
    datum = jubatus.set_datum({str_key: "message", str_data: msg})
    result = jubatus.classify(jubatus.jubatus, [datum])
    res = false
    unless result.nil? || result[0].empty?
      est = get_most_likely(result[0])
      res = est[0] == 'favorite'
    end
    return res
  rescue => e
    STDERR.puts e
    return res
  end

  def get_most_likely(estimates)
    result = nil
    estimates.map do |estm|
      result = estm if result.nil? or result[1].to_f < estm[1].to_f
    end
    return result
  end
end
