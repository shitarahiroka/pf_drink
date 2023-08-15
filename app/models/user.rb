class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :drink_records
  validates :name, presence: true, length: { maximum: 255 }
  validates :email, uniqueness: true
  validates :email, presence: true

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :reset_password_token, uniqueness: true, allow_nil: true

  enum gender: { 男性: 0, 女性: 1 }
  enum area: {
    北海道: 1,
    青森: 2,
    岩手: 3,
    宮城: 4,
    秋田: 5,
    山形: 6,
    福島: 7,
    茨城: 8,
    栃木: 9,
    群馬: 10,
    埼玉: 11,
    千葉: 12,
    東京: 13,
    神奈川: 14,
    新潟: 15,
    富山: 16,
    石川: 17,
    福井: 18,
    山梨: 19,
    長野: 20,
    岐阜: 21,
    静岡: 22,
    愛知: 23,
    三重: 24,
    滋賀: 25,
    京都: 26,
    大阪: 27,
    兵庫: 28,
    奈良: 29,
    和歌山: 30,
    鳥取: 31,
    島根: 32,
    岡山: 33,
    広島: 34,
    山口: 35,
    徳島: 36,
    香川: 37,
    愛媛: 38,
    高知: 39,
    福岡: 40,
    佐賀: 41,
    長崎: 42,
    熊本: 43,
    大分: 44,
    宮崎: 45,
    鹿児島: 46,
    沖縄: 47
  }
  def calculate_caffeine_limit
    if weight.nil? || age.nil?
      caffeine_limit = 400
    elsif age.between?(13, 18)
      caffeine_limit = 100
    else
      weight_in_kg = weight.to_f
      caffeine_limit = (6 * weight_in_kg).round(2)
    end

    "#{caffeine_limit}mg"
  end
end
