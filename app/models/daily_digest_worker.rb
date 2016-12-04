#class DailyDigestWorker
#  include Sidekiq::Worker
#  include Sidetiq::Schedualbe
#
#  recurrence { daily(1) }
#  def perfom
#    User.send_daily_digest
#  end
#end