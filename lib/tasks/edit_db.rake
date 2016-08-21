namespace :edit_db do
  desc "Delete all ekhtsrni urls in bd"
  task deleteEkhtsrniUrls: :environment do
    AnonymousUrl.all.each do |url|
      if url.url.include?('ekhtsr')
        url.destroy
      end
    end
  end
  
  desc "Delete all messages"
  task deleteMessages: :environment do
    Message.all.each do |msg|
      msg.destroy
    end
  end
  
end
