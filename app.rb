require 'sinatra/base'
require 'sass'
require 'redcarpet'
require './models/facts'

class SassHandler < Sinatra::Base   
  set :views, File.dirname(__FILE__) + '/templates/sass'
  
  get '/stylesheets/*.css' do
      filename = params[:splat].first
      scss filename.to_sym
  end  
end

module DinosaursEatEverybody
  class App < Sinatra::Base
    use SassHandler

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)

    # routes
    get '/' do
      @page_title = "home"
      erb :index
    end

    get '/blog/?*' do
      jekyll_blog(request.path)
    end

    get '/post/:id' do
      @title = "This is post #{params[:id]}"
      @page_title = @title
      @body = markdown.render("How does *this* look? will this turn into a link? www.dinosaurseateverybody.com")
      erb :post
    end

    get '/about' do
      @page_title = "about"
      erb :about
    end

    get '/music' do
      @page_title = "music"
      erb :music
    end

    get '/links' do
      @page_title = "links"
      erb :links
    end

    get '/projects' do
      @page_title = "projects"
      erb :projects
    end

    helpers do
      def dave_fact 
        the_facts = Facts.new
        fact_id = (0..the_facts.count-1).to_a.sample
        the_facts.get_fact(fact_id)
      end
    end

    def jekyll_blog(path)
      @page_title = "blog"

      puts "path>............."
      puts path

      file_path = File.join(File.dirname(__FILE__), 'jekyll_blog/_site',  path.gsub('/blog',''))
      file_path = File.join(file_path, 'index.html') unless file_path =~ /\.[a-z]+$/i 

      puts "file_path is.........................."
      puts file_path

      if File.exist?(file_path)
        file = File.open(file_path, "rb")
        contents = file.read
        file.close
    
        if (file_path.include?('.xml') || file_path.include?('.css'))
          erb contents, :content_type => 'text/xml'
        else
          erb contents
        end
      end
    end

    run! if app_file == $0
  end
end
