class User < ActiveRecord::Base
  has_many :texts, :dependent => :destroy

  def send_text( args = {} )
    args = Hash[args.map{ |k, v| [k.to_sym, v] }] #turns all keys to symbols
    args = {:from => '+14158738769'}.merge(args)

    text = Text.create( :from => args[:from], :to => args[:to], 
                        :body => args[:body], :user_id => self.id )

    args = args.merge({:text_id => text.id})


    if args[:date] == "" && args[:time] == ""
      puts "texting immediately"
      puts "@"*100
      puts args
      job_id = TextWorker.perform_async( args )

    else
      run_at = with_time_zone(args[:timezone]){Time.strptime("#{args[:date]} #{args[:time]}", "%m/%d/%Y %I:%M %p")}.utc

      args = args.slice!(:date, :time, :timezone)
      puts "scheduling text"
      puts "&"*500
      puts args
      job_id = TextWorker.perform_at( run_at, args )
    end
    job_id
  end


  def with_time_zone(tz_name)
    prev_tz = ENV['TZ']
    ENV['TZ'] = tz_name
    yield
  ensure
    ENV['TZ'] = prev_tz
  end   

end
