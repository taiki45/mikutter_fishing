# -*- coding: utf-8 -*-

Plugin.create :mikutter_fishing do

  hook = "|\nし"
  hook_and_bait = /#{Regexp.escape(hook)}\s*\[([^\]]*)\]$/u
  hook_template = ->(bait){ "#{hook} [#{bait}]" }

  be_fished = ->(msg){
    if msg.body =~ hook_and_bait
      bait = $1
      link = "http://twitter.com/#{msg.user}/status/#{msg.id}"
      Service.primary.post message: "#{bait}に釣られたでし…  #{link}"
    end
  }

  fish = ->(bait){
    Service.primary.post message: hook_template.(bait)
  }

  command(
    :be_fished,
    name: "釣られる",
    condition: -> _ { true },
    visible: true,
    role: :timeline
  ) do |opt|
    opt.messages.each do |m|
      be_fished.(m)
    end
  end

  command(
    :fish,
    name: "釣る",
    condition: -> _ { true },
    visible: true,
    role: :postbox
  ) do |opt|
    buff = ::Plugin.create(:gtk).widgetof(opt.widget).widget_post.buffer
    fish.(buff.text)
    buff.text = ""
  end

end
