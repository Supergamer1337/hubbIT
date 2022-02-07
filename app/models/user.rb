class User < ActiveResource::Base
  extend ActiveModel::Naming
  self.site = Rails.configuration.account_ip
  self.prefix = "/api/"
  ALLOWED_GROUPS = [:styrit, :snit, :sexit, :prit, :nollkit, :armit, :digit, :fanbarerit, :fritid, :8bit, :drawit, :flashit, :hookit, :revisorer, :valberedningen, :laggit, :fikit, :dpo, :kandidatmiddagen, :jubileumsmiddag, :equalit, :talpersonht, :talpersonvt ]

  def devices
    @devices ||= MacAddress.where user_id: self.cid
  end

  def self.find(id)
    return nil unless id.present?
    Rails.cache.fetch("users/#{id}.json", expires_in: 2.hours) do
      super id
    end
  end

  def devices=(input)
    @devices = input
  end

  def sessions
    @sessions ||= Session.where user_id: self.cid
  end

  def user_sessions
    @usessions ||= UserSession.where user_id: self.cid
  end

  def hour_entries
    @hentries ||= HourEntry.where cid: self.cid
  end

  def self.headers
    { 'authorization' => "pre-shared #{Rails.application.secrets.client_credentials}" }
  end

  def destroy
    devices.delete_all
    sessions.delete_all
    user_sessions.delete_all
    hour_entries.delete_all
  end
end

class Symbol
  def itize
    case self
      when :digit, :styrit, :sexit, :fritid, :snit
        self.to_s.gsub /it/, 'IT'
      when :drawit, :armit, :hookit, :flashit, :laggit, :fikit, :equalit
        self.to_s.titleize.gsub /it/, 'IT'
      when :8bit
        '8-bIT'
      when :nollkit
        'NollKIT'
      when :prit
        'P.R.I.T.'
      when :fanbarerit
        'FanbärerIT'
      when :valberedningen
        'Valberedningen'
      when :revisorer
        'Revisorerna'
      when :dpo
        'DPO'
      when :kandidatmiddagen
        'Kandiatmiddagsgruppen' 
      when :jubileumsmiddag
        'Jubileumsmiddagsgruppen'
      when :talpersonht, :talpersonvt
        'Talperson' 
      else
        self.to_s
    end
  end
end
