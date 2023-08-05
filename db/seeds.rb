# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# ドリンクデータの配列(150ml or bottle)
drinks_data = [
  { name: "コーヒー", calories: 6.0, caffeine: 90.0, teanine: 0, mood: "集中重視" },
  { name: "紅茶", calories: 2.5, caffeine: 45.0, teanine: 1, mood: "リラックスしながら" },
  { name: "煎茶", calories: 1.5, caffeine: 30.0, teanine: 1, mood: "リラックスしながら" },
  { name: "ほうじ茶", calories: 0.0, caffeine: 30.0, teanine: 1, mood: "リラックスしながら" },
  { name: "コカコーラ", calories: 225.0, caffeine: 47.9, teanine: 0, mood: "エネルギー補給" },
  { name: "ペプシコーラ", calories: 235.2, caffeine: 53.5, teanine: 0, mood: "エネルギー補給" },
  { name: "オロナミンC", calories: 80.0, caffeine: 19.0, teanine: 0, mood: "エネルギー補給" },
  { name: "ミルクココア", calories: 60.0, caffeine: 3.0, teanine: 0, mood: "リラックスしながら" },
  { name: "レッドブル", calories: 115.0, caffeine: 80.0, teanine: 0, mood: "エネルギー補給" },
  { name: "モンスターエナジー", calories: 177.5, caffeine: 160.0, teanine: 0, mood: "集中重視" },
  { name: "レッドブルシュガーフリー", calories: 0.0, caffeine: 80.0, teanine: 0, mood: "エネルギー補給" },
  { name: "烏龍茶", calories: 0.0, caffeine: 30.0, teanine: 1, mood: "リラックスしながら" },
  { name: "ジャスミン茶", calories: 0.0, caffeine: 30.0, teanine: 1, mood: "リラックスしながら" },
  { name: "玄米茶", calories: 0.0, caffeine: 15.0, teanine: 1, mood: "リラックスしながら" },
  { name: "カフェオレ", calories: 60.0, caffeine: 60.0, teanine: 0, mood: "集中重視" },
  { name: "抹茶ラテ", calories: 156.0, caffeine: 80.0, teanine: 1, mood: "エネルギー補給" },
  { name: "ほうじ茶ラテ", calories: 118.0, caffeine: 14.0, teanine: 1, mood: "エネルギー補給" }
]
# ドリンクデータの作成
drinks_data.each do |data|
  Drink.find_or_create_by(data)
end