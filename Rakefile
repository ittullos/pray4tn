# frozen_string_literal: true

# require 'bundler'
# Bundler.require
# require 'dotenv'
# require 'roo'
# puts ENV['RACK_ENV']
# Dotenv.load

require 'sinatra/activerecord/rake'

namespace :db do
  desc 'loads application'
  task :load_config do
    require './app/app'
  end
end

# names       = ['John Stewart', 'Stephen Colbert', 'Trever Noah']
# addresses   = ['44 Unknown dr', '431 Canberra dr', '607 Middlebrook pk']

#   desc 'Seed Verses'
#   task :seed_verses do
#     Verse.new_verse(
#       scripture: 'Love is patient and kind; love does not envy or boast; it is not arrogant or rude. It does not insist on its own way; it is not irritable or resentful.',
#       version: 'ESV',
#       notation: '1 Corinthians 13:4-5'
#     )
#     Verse.new_verse(
#       scripture: 'Rejoice always, pray without ceasing, give thanks in all circumstances; for this is the will of God in Christ Jesus for you.',
#       version: 'ESV',
#       notation: '1 Thessalonians 5:16-18'
#     )
#     Verse.new_verse(
#       scripture: 'Do not be anxious about anything, but in everything by prayer and supplication with thanksgiving let your requests be made known to God. And the peace of God, which surpasses all understanding, will guard your hearts and your minds in Christ Jesus.',
#       version: 'ESV',
#       notation: 'Philippians 4:6-7'
#     )
#     user_id = User.new_user(email: 'user@example.com', password: '1')
#   end

#   desc 'Seed 100 Verses'
#   task :seed_100_verses do
#     # clean_table(Verse)
#     file = Roo::Spreadsheet.open('./db/verses/100_verses.xlsx')
#     # pry.byebug
#     for i in 91..101
#       Verse.new_verse(
#         day: (i + -2),
#         version: 'CSB',
#         notation: file.cell(i, 1),
#         scripture: file.cell(i, 2)
#       )
#       puts "Day: #{i - 2}, Version: #{file.cell(i, 2)}"
#     end
#   end

#   desc 'Seed Devotionals'
#   task :seed_devo do
#     Devotional.new_devotional(
#       id: 1,
#       title: 'Solid Joys Daily Devotional - Finally and Totally Justified (2/28)',
#       url: 'https://d1bxy2pveef3fq.cloudfront.net/episodes/original/22488574?episode_id=14092641&show_id=2747060&user_id=9300615&organization_id=9627600&tenant=SPREAKER&timestamp=1677598250&media_type=static&Expires=1677857450&Key-Pair-Id=K1J2BR3INU6RYD&Signature=L8UiK2aSDDi3djzz8E4XiL43thS8TJUjIH0iAtPrAfNj~1kXjz-uO0Rr8WF~dCmU8EgXZtooWBNDlQ21b4IywTXbMYygfeDz01KaF~ZLlvaqsOj-f2-M2~3g4RFTLMY2dhgJmgjDMoqTsbt4CdTBZCT5yVzzK11oTNK2VAKIUGOfzEXrHZPhlc0-hUS5hLqVvmO1gfE459gB1HKqldtuSk52Etd~FGH0DTyQGuli674KWLUgIrBn1oshF4edXZaPl0mD2tgC1xD~mSwzSLoOQ5shDmHH0UqNn6GbdNaqgoCbFDU4v6k8Mmgq46M8ZLoHHmd4PjnEraUNnih1B7LCfA__',
#       img_url: 'https://static.feedpress.com/logo/solid-joys-audio-5a0dd6d2592f3.png'
#     )
#     Devotional.new_devotional(
#       id: 2,
#       title: 'Solid Joys Daily Devotional - God Opens the Heart (2/24)',
#       url: 'https://feed.desiringgod.org/link/18331/8373314/14092385.mp3',
#       img_url: 'https://static.feedpress.com/logo/solid-joys-audio-5a0dd6d2592f3.png'
#     )
#     Devotional.new_devotional(
#       id: 3,
#       title: 'Solid Joys Daily Devotional - Amazed at the Resurrection (2/20)',
#       url: 'https://feed.desiringgod.org/link/18331/8334555/14004201.mp3',
#       img_url: 'https://static.feedpress.com/logo/solid-joys-audio-5a0dd6d2592f3.png'
#     )
#     Devotional.new_devotional(
#       id: 4,
#       title: 'The Walk: Devotionals for Worshippers - David Funk',
#       url: 'https://api.spreaker.com/download/episode/52817454/the_walk_david_funk_final.mp3?dl=true',
#       img_url: 'https://worshipleader.com/wp-content/uploads/2023/02/David-Funk_artwork-1160x1160.jpg'
#     )
#     Devotional.new_devotional(
#       id: 5,
#       title: 'The Walk: Devotionals for Worshippers - Lecrae',
#       url: 'https://api.spreaker.com/download/episode/52750116/the_walk_lacrae_final.mp3?dl=true',
#       img_url: 'https://worshipleader.com/wp-content/uploads/2023/02/Lecrae_artwork-1160x1160.jpg'
#     )
#     Devotional.new_devotional(
#       id: 6,
#       title: 'Solid Joys Daily Devotional - Justin Warren',
#       url: 'https://api.spreaker.com/download/episode/52126658/the_walk_justin_warren_final.mp3?dl=true',
#       img_url: 'https://worshipleader.com/wp-content/uploads/2022/12/Justin-Warren_artwork-1160x1160.jpg'
#     )
#   end

#   task :seed_users do
#     User.new_user(
#       email: 'isaac.tullos@gmail.com',
#       password: '1',
#       commitment_id: 0
#     )
#   end

#   task :seed_journeys do
#     clean_table(Journey)
#     Journey.new_journey(
#       title: 'I-65 from Franklin to Nashville',
#       target_miles: 21_500,
#       graphic_url: 'https://s3.amazonaws.com/wpt.bap.tn.journey-images/franklin_nashville.png'
#     )
#     Journey.new_journey(
#       title: 'I-40 accross the entire state',
#       target_miles: 455_280,
#       graphic_url: 'https://s3.amazonaws.com/wpt.bap.tn.journey-images/I40_across_tn.png'
#     )
#   end

#   task :seed_commits do
#     Commitment.initial_seed
#   end
# end
