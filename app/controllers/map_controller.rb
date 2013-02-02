class MapController < ApplicationController
  

  # renders the index view and anything else if needed
  def index
  end

  # find the proximity of items to the company
  def search
    @company = Company.find_by_name(params[:name])
    @company = JSON.parse(@company)
    render :json => @company.to_json and return unless @company.nil?
    render :json => {error: "No record  found"}, status: :not_found
  end

  # get all companies
  def all_companies
    @companies = []
    Company.all.each do |comp|
      comp = comp.to_json 
      @companies << JSON.parse(comp)
      puts comp 
    end
    render :json => @companies.to_json and return unless @companies.nil?
    render :json => {error: "Empty database????"}, status: :not_found
  end 
  # add the new company to our DB
  def update
  end

  # google API request to find the lat/long of the company
  def find_company_by_address
  end

end
