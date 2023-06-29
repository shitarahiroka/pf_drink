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

  enum gender: { male: 0, female: 1, other: 2 }
  enum area: {
    hokkaido: 1,
    aomori: 2,
    iwate: 3,
    miyagi: 4,
    akita: 5,
    yamagata: 6,
    fukushima: 7,
    ibaraki: 8,
    tochigi: 9,
    gunma: 10,
    saitama: 11,
    chiba: 12,
    tokyo: 13,
    kanagawa: 14,
    niigata: 15,
    toyama: 16,
    ishikawa: 17,
    fukui: 18,
    yamanashi: 19,
    nagano: 20,
    gifu: 21,
    shizuoka: 22,
    aichi: 23,
    mie: 24,
    shiga: 25,
    kyoto: 26,
    osaka: 27,
    hyogo: 28,
    nara: 29,
    wakayama: 30,
    tottori: 31,
    shimane: 32,
    okayama: 33,
    hiroshima: 34,
    yamaguchi: 35,
    tokushima: 36,
    kagawa: 37,
    ehime: 38,
    kochi: 39,
    fukuoka: 40,
    saga: 41,
    nagasaki: 42,
    kumamoto: 43,
    oita: 44,
    miyazaki: 45,
    kagoshima: 46,
    okinawa: 47
  }
end
