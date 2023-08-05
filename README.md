# intell drink（インテリ　ドリンク）

## サービス概要
学習や仕事の時に集中したい人におすすめのドリンクを提供するアプリ  
カフェイン摂取量が気になるけれど管理は面倒くさい人が簡単に制限できるアプリ  

## メインのターゲットユーザー
学習中の人やデスクワークの人  
コーヒーやエナジードリンクなどのカフェイン含有ドリンクをよく飲む人  

## ユーザーが抱える課題
学習や仕事に集中したいが、飲むドリンクを選ぶのに迷う・マンネリ化している・カフェイン摂取量が気になっている。  
カフェイン摂取量は気になるが、記録したりするのは面倒くさいと感じている。  

## 課題に対する仮説
ドリンクを選ぶのに迷う・マンネリ化・カフェイン摂取量が気になる  
→好みなどからおすすめのドリンクを提案してくれて、1日のプランで提案することでカフェイン摂取量を制限できる  
カフェイン摂取量の記録は面倒くさい  
→提案したドリンクプランをもとに自動記録することで管理を簡単にできる  

## 解決方法
- ユーザーの学習や仕事の目的や好み、時間帯などを考慮し、集中力を高める効果的なドリンクを提案することで迷いやマンネリをなくす  
- ユーザーの個別の情報（体重、年齢）を考慮して1日に摂取できるカフェイン量の目安を設定し、ドリンクを選ぶだけでカフェインの制限を行うことで管理を簡単にする  


## 実装予定の機能（以下の例は実際のアプリの機能から一部省略しています）
- 未登録ユーザー
    - 1日のドリンクの提案機能
        - ユーザーがドリンク提案フォームで情報を入力できる
        - ユーザーがドリンク提案ページで結果を見ることができる

- 登録ユーザー
	- カフェイン摂取量の登録機能
		- ユーザープロフィール作成ページで、ユーザーの個別の情報（体重、健康状態など）を入力できるようにする。
	    - ユーザーの入力した情報から1日のカフェイン摂取量を見ることができる
    - 1日のドリンクの提案機能（カフェイン摂取量制限）
        - ユーザーがドリンク提案フォームで情報を入力できる
        - ユーザーがドリンク提案ページで結果を見ることができる
		- カフェイン摂取量を踏まえてドリンクを制限することができる
	- カフェイン摂取量の記録機能
		- 提案したドリンクを記録できる
		- 記録したカフェイン摂取量をカレンダーで確認できる

＊＊＊＊＊以下未実装＊＊＊＊＊
	- 評価機能
		- 記録したドリンクが合う・合わないを選択できる

## なぜこのサービスを作りたいのか？
現在も教員時代も生活の中に常に学習があり、集中して学習できるドリンクを知りたいと思った。  
また、毎日のカフェイン摂取量を気にしながらもいちいち調べたりメモして管理するのが面倒で、改善まで至らなかったので、簡単に制限できたらいいなと思った。  

## スケジュール（フルコミット）
企画（アイデア企画・技術調査）：4月中  
設計（README作成・画面遷移図作成・ER図作成）：5/19  
機能実装：6〜7月
MVPリリース：7月末
本リリース：8月中

## 技術選定
- Rails7

## 画面遷移図
https://www.figma.com/file/Ig9LmDQGdgDyw9WdZIVjR5/PF%E3%81%AE%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&node-id=0%3A1&t=X1G2zhAsaKjRsEgV-1
