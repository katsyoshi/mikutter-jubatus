# -*- coding: utf-8 -*-
dirname = File.dirname(File.expand_path(__FILE__))
require dirname + '/jubamikutter.rb'

Plugin.create(:jubatus) do
  on_boot do
    @msgq = []
    @jubamikutter = JubaMikutter.new(dirname+'/learn.conf')
  end

  on_update do |service, message|
    if !message.empty?
      message.map do |msg|
        classify msg
      end
    end
  end

  def classify(msg)
    sgs = suggestion(@jubamikutter, msg.to_s)
    STDERR.print "classify:#{sgs.to_s}"
    data = {str_key: 'message', str_data: msg.to_s}
    datum = @jubamikutter.set_datum(data)

    if sgs
      delay_fav(msg) if UserConfig[:jubatus_auto]
    else
      if UserConfig[:jubatus_train] == true
        train = @jubamikutter.train(@jubamikutter.jubatus, [["tweet",datum]])
        STDERR.print "\ttrain:#{train.to_s}"
      end
    end
  rescue => e
    STDERR.print "\terror:#{e.to_s}"
  ensure
    STDERR.puts ''
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

  on_favorite do |service, user, message|
    begin
      if UserConfig[:jubatus_train] && user == service.user
        data = {str_key: 'message', str_data: message.to_s}
        datum = @jubamikutter.set_datum(data)
        train = @jubamikutter.train(@jubamikutter.jubatus, [["favorite", datum]])
        STDERR.print "user:#{user}\ttrain:#{train.to_s}\n"
      end
    rescue => e
      STDERR.puts "error:#{e.to_s}"
    end
  end

  def delay_fav(message)
    sec = rand(UserConfig[:jubatus_delay].to_i)
    return sec if message.from_me?
    Reserver.new(sec.to_i) do
      message.favorite(true) if !message.favorite?
    end
    return sec
  end

end
