var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"は有効でありません。","confirmation":"が内容とあっていません。","accepted":"must be accepted","empty":"can't be empty","blank":"が入力されていません。","present":"must be blank","too_long":"は%{count}文字以下に設定して下さい。","too_short":"は%{count}文字以上に設定して下さい。","wrong_length":"is the wrong length (should be %{count} characters)","not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"は既に使用されています。","carrierwave_processing_error":"failed to be processed","carrierwave_integrity_error":"is not of an allowed file type","carrierwave_download_error":"could not be downloaded","extension_white_list_error":"You are not allowed to upload %{extension} files, allowed types: %{allowed_types}","extension_black_list_error":"You are not allowed to upload %{extension} files, prohibited types: %{prohibited_types}","rmagick_processing_error":"Failed to manipulate with rmagick, maybe it is not an image? Original Error: %{e}","mime_types_processing_error":"Failed to process file with MIME::Types, maybe not valid content-type? Original Error: %{e}","mini_magick_processing_error":"Failed to manipulate with MiniMagick, maybe it is not an image? Original Error: %{e}","already_confirmed":"was already confirmed, please try signing in","confirmation_period_expired":"needs to be confirmed within %{period}, please request a new one","expired":"has expired, please request a new one","not_found":"not found","not_locked":"was not locked","not_saved":{"one":"1 error prohibited this %{resource} from being saved:","other":"%{count} errors prohibited this %{resource} from being saved:"}}},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"flash":{"actions":{"create":{"notice":"%{resource_name} was successfully created."},"update":{"notice":"%{resource_name} was successfully updated."},"destroy":{"notice":"%{resource_name} was successfully destroyed.","alert":"%{resource_name} could not be destroyed."}}},"devise":{"confirmations":{"confirmed":"Your email address has been successfully confirmed.","send_instructions":"You will receive an email with instructions for how to confirm your email address in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes."},"failure":{"already_authenticated":"You are already signed in.","inactive":"Your account is not activated yet.","invalid":"Invalid %{authentication_keys} or password.","locked":"Your account is locked.","last_attempt":"You have one more attempt before your account is locked.","not_found_in_database":"Invalid %{authentication_keys} or password.","timeout":"Your session expired. Please sign in again to continue.","unauthenticated":"You need to sign in or sign up before continuing.","unconfirmed":"You have to confirm your email address before continuing."},"mailer":{"confirmation_instructions":{"subject":"Confirmation instructions"},"reset_password_instructions":{"subject":"Reset password instructions"},"unlock_instructions":{"subject":"Unlock instructions"}},"omniauth_callbacks":{"failure":"Could not authenticate you from %{kind} because \"%{reason}\".","success":"Successfully authenticated from %{kind} account."},"passwords":{"no_token":"You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.","send_instructions":"You will receive an email with instructions on how to reset your password in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.","updated":"Your password has been changed successfully. You are now signed in.","updated_not_active":"Your password has been changed successfully."},"registrations":{"destroyed":"Bye! Your account has been successfully cancelled. We hope to see you again soon.","signed_up":"Welcome! You have signed up successfully.","signed_up_but_inactive":"You have signed up successfully. However, we could not sign you in because your account is not yet activated.","signed_up_but_locked":"You have signed up successfully. However, we could not sign you in because your account is locked.","signed_up_but_unconfirmed":"A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.","update_needs_confirmation":"You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.","updated":"Your account has been updated successfully."},"sessions":{"signed_in":"","signed_out":"","already_signed_out":""},"unlocks":{"send_instructions":"You will receive an email with instructions for how to unlock your account in a few minutes.","send_paranoid_instructions":"If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.","unlocked":"Your account has been unlocked successfully. Please sign in to continue."}},"hello":"Hello world","header_menu":{"file":{"newcreate":"Create NewProject","file":"File","open":"Open","save":"Save","load":"Load","setting":"Setting","new_file":"New File","all_save":"Save all code"},"action":{"action":"Action","select_action":"(Select Action)","draw":{"draw":"Draw","arrow":"Arrow","button":"Button"},"preload_item":"Default items","added_item":"Added items","edit":"Edit","item_coding":"Create Item"},"motion_check":{"title":"Motion Check","newtab":"New Tab","newwindow":"Run with Window"},"etc":{"etc":"Etc","language":"Language","introduction":"introduction","about":"About","back_to_mainpage":"Back to MainPage","last_update_date":"Last update"},"setting":{"show_guide":"Toggle Guide"}},"context_menu":{"new_file":"New File","new_folder":"New Folder","js":"JavaScript","coffee":"CoffeeScript","copy":"Copy","cut":"Cut","paste":"Paste","float":"Float","rear":"Rear","delete":"Delete","edit":"Edit"},"config":{"state":{"page_num":"Page number","display_position":"Display Position","zoom":"Zoom rate","created_item_list":"Created item's list"},"select_opt_group":{"common":"Common Event","item":"Item"}},"upload_confirm":{"title":"Title name","caption":"Caption","tags":"Tags","popular_tags":"Popular tags","recommend_tags":"Recommend tags","version":"Version","show_guide":"Show Motion Guide","show_page_num":"Show Page Number","show_chapter_num":"Show Chapter Number"},"message":{"dialog":{"new_project":"All the contents making will delete.","delete_item":"The item will delete.","update_gallery":"Upload","delete_node":"The contents (and subtree) will delete."},"database":{"item_state":{"save":{"success":"","error":""},"load":{"error":""}}},"gallery":{"upload":{"save":{"success":"","error":""}}}},"common_action":{"background":"Background","screen":"Screen"},"test":"testok"},"ja":{"hello":"こんにちは","header_menu":{"file":{"newcreate":"プロジェクトを新規作成","file":"ファイル","open":"開く","save":"保存","load":"読み込み","setting":"設定","new_file":"新規ファイル","all_save":"全保存"},"action":{"action":"アクション","select_action":"(アクションを選択してください)","draw":{"draw":"描画","arrow":"矢印","button":"ボタン"},"preload_item":"標準アイテム","added_item":"追加アイテム","edit":"編集","item_coding":"アイテム作成"},"motion_check":{"title":"動作確認","newtab":"新タブで実行","newwindow":"新ウィンドウで実行"},"etc":{"etc":"その他","language":"言語","introduction":"自己紹介","about":"このサイトについて","back_to_mainpage":"メインページに戻る","last_update_date":"最新更新時間"},"setting":{"show_guide":"モーションガイド切り替え"}},"context_menu":{"new_file":"新規ファイル","new_folder":"新規フォルダ","copy":"コピー","cut":"切り取り","paste":"貼り付け","float":"最前面に移動","rear":"再背面に移動","delete":"削除","edit":"編集"},"config":{"state":{"page_num":"ページ番号","display_position":"表示位置","zoom":"表示倍率","created_item_list":"作成アイテム一覧"},"select_opt_group":{"common":"共通イベント","item":"アイテム"}},"upload_confirm":{"title":"タイトル名","caption":"説明","tags":"タグ","popular_tags":"人気のタグ","recommend_tags":"おすすめのタグ","version":"バージョン","show_guide":"モーションガイドを表示","show_page_num":"ページ番号を表示","show_chapter_num":"チャプター番号を表示"},"message":{"dialog":{"new_project":"'作成中のコンテンツは全て削除されます。'","delete_item":"アイテムが削除されます。","update_gallery":"アップロードします。","delete_node":"削除してよろしいですか？ サブツリーが存在する場合、同時に削除されます。"},"database":{"item_state":{"save":{"success":"アイテムの状態を保存しました。","error":"アイテムの保存に失敗しました。"},"load":{"success":"アイテムの状態を読み込みました。","error":"アイテムの読み込みに失敗しました。"}}},"gallery":{"upload":{"save":{"success":"","error":""}}}},"common_action":{"background":"背景","screen":"画面表示"},"activerecord":{"attributes":{"user":{"name":"名前","password":"パスワード","password_confirmation":"パスワード確認","email":"メールアドレス"}}}}};