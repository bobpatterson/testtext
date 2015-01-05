get '/' do
  
  erb :index
end

post '/text/schedule' do
  texts = 1 + params[:text][:body].length / 160
  
  if texts > 3
    return "You crazy, that's #{texts} texts at once. Pick up the phone!"
  end

  if texts == 1
    u = User.create( email: "j@lifthero.com" )

    u.send_text(params[:text])
    redirect '/'
  else
    body_chars = params[:text][:body].chars.to_a
    texts.times do
      msg = body_chars.shift(160).join("")
      Text.send( :to => params[:text][:to], :body => msg )
      redirect '/'
    end
  end  

end

