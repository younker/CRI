class SingleController < ApplicationController
  helper Blog::BlogsHelper

  def homepage
    @project_context = Blog::Context.where(:context_type => 'Projects').limit(1).first
    @project = Blog::Blog.where(:context_id => @project_context.id).limit(1).first

    @news_context = Blog::Context.where(:context_type => 'News').limit(1).first
    @news = Blog::Blog.where(:context_id => @news_context.id).limit(10)
  end

  def donate
    
  end
  
  def resources
    
  end

  def privacy_policy
  end

  def mission_statement
  end

  def faq
  end

end
