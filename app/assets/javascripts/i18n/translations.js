var I18n = I18n || {};
I18n.translations = {"en":{"date":{"formats":{"default":"%Y-%m-%d","short":"%b %d","long":"%B %d, %Y"},"day_names":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"abbr_day_names":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"month_names":[null,"January","February","March","April","May","June","July","August","September","October","November","December"],"abbr_month_names":[null,"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"order":["year","month","day"]},"time":{"formats":{"default":"%a, %d %b %Y %H:%M:%S %z","short":"%d %b %H:%M","long":"%B %d, %Y %H:%M"},"am":"am","pm":"pm"},"support":{"array":{"words_connector":", ","two_words_connector":" and ","last_word_connector":", and "}},"number":{"format":{"separator":".","delimiter":",","precision":3,"significant":false,"strip_insignificant_zeros":false},"currency":{"format":{"format":"%u%n","unit":"$","separator":".","delimiter":",","precision":2,"significant":false,"strip_insignificant_zeros":false}},"percentage":{"format":{"delimiter":"","format":"%n%"}},"precision":{"format":{"delimiter":""}},"human":{"format":{"delimiter":"","precision":3,"significant":true,"strip_insignificant_zeros":true},"storage_units":{"format":"%n %u","units":{"byte":{"one":"Byte","other":"Bytes"},"kb":"KB","mb":"MB","gb":"GB","tb":"TB"}},"decimal_units":{"format":"%n %u","units":{"unit":"","thousand":"Thousand","million":"Million","billion":"Billion","trillion":"Trillion","quadrillion":"Quadrillion"}}}},"errors":{"format":"%{attribute} %{message}","messages":{"inclusion":"is not included in the list","exclusion":"is reserved","invalid":"is invalid","confirmation":"doesn't match %{attribute}","accepted":"must be accepted","empty":"can't be empty","blank":"can't be blank","present":"must be blank","too_long":"is too long (maximum is %{count} characters)","too_short":"is too short (minimum is %{count} characters)","wrong_length":"is the wrong length (should be %{count} characters)","not_a_number":"is not a number","not_an_integer":"must be an integer","greater_than":"must be greater than %{count}","greater_than_or_equal_to":"must be greater than or equal to %{count}","equal_to":"must be equal to %{count}","less_than":"must be less than %{count}","less_than_or_equal_to":"must be less than or equal to %{count}","other_than":"must be other than %{count}","odd":"must be odd","even":"must be even","taken":"has already been taken","carrierwave_processing_error":"failed to be processed","carrierwave_integrity_error":"is not of an allowed file type","carrierwave_download_error":"could not be downloaded","extension_white_list_error":"You are not allowed to upload %{extension} files, allowed types: %{allowed_types}","extension_black_list_error":"You are not allowed to upload %{extension} files, prohibited types: %{prohibited_types}","rmagick_processing_error":"Failed to manipulate with rmagick, maybe it is not an image? Original Error: %{e}","mime_types_processing_error":"Failed to process file with MIME::Types, maybe not valid content-type? Original Error: %{e}","mini_magick_processing_error":"Failed to manipulate with MiniMagick, maybe it is not an image? Original Error: %{e}","already_confirmed":"was already confirmed, please try signing in","confirmation_period_expired":"needs to be confirmed within %{period}, please request a new one","expired":"has expired, please request a new one","not_found":"not found","not_locked":"was not locked","not_saved":{"one":"1 error prohibited this %{resource} from being saved:","other":"%{count} errors prohibited this %{resource} from being saved:"}}},"activerecord":{"errors":{"messages":{"record_invalid":"Validation failed: %{errors}","restrict_dependent_destroy":{"one":"Cannot delete record because a dependent %{record} exists","many":"Cannot delete record because dependent %{record} exist"}}},"attributes":{"user":{"name":"Name","password":"Password","password_confirmation":"Password Confirm","email":"Mail Address","remember_me":"Remember me"}}},"datetime":{"distance_in_words":{"half_a_minute":"half a minute","less_than_x_seconds":{"one":"less than 1 second","other":"less than %{count} seconds"},"x_seconds":{"one":"1 second","other":"%{count} seconds"},"less_than_x_minutes":{"one":"less than a minute","other":"less than %{count} minutes"},"x_minutes":{"one":"1 minute","other":"%{count} minutes"},"about_x_hours":{"one":"about 1 hour","other":"about %{count} hours"},"x_days":{"one":"1 day","other":"%{count} days"},"about_x_months":{"one":"about 1 month","other":"about %{count} months"},"x_months":{"one":"1 month","other":"%{count} months"},"about_x_years":{"one":"about 1 year","other":"about %{count} years"},"over_x_years":{"one":"over 1 year","other":"over %{count} years"},"almost_x_years":{"one":"almost 1 year","other":"almost %{count} years"}},"prompts":{"year":"Year","month":"Month","day":"Day","hour":"Hour","minute":"Minute","second":"Seconds"}},"helpers":{"select":{"prompt":"Please select"},"submit":{"create":"Create %{model}","update":"Update %{model}","submit":"Save %{model}"}},"flash":{"actions":{"create":{"notice":"%{resource_name} was successfully created."},"update":{"notice":"%{resource_name} was successfully updated."},"destroy":{"notice":"%{resource_name} was successfully destroyed.","alert":"%{resource_name} could not be destroyed."}}},"devise":{"confirmations":{"confirmed":"Your email address has been successfully confirmed.","send_instructions":"You will receive an email with instructions for how to confirm your email address in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes."},"failure":{"already_authenticated":"You are already signed in.","inactive":"Your account is not activated yet.","invalid":"Invalid %{authentication_keys} or password.","locked":"Your account is locked.","last_attempt":"You have one more attempt before your account is locked.","not_found_in_database":"Invalid %{authentication_keys} or password.","timeout":"Your session expired. Please sign in again to continue.","unauthenticated":"You need to sign in or sign up before continuing.","unconfirmed":"You have to confirm your email address before continuing."},"mailer":{"confirmation_instructions":{"subject":"Confirmation instructions"},"reset_password_instructions":{"subject":"Reset password instructions"},"unlock_instructions":{"subject":"Unlock instructions"},"password_change":{"subject":"Password Changed"}},"omniauth_callbacks":{"failure":"Could not authenticate you from %{kind} because \"%{reason}\".","success":"Successfully authenticated from %{kind} account."},"passwords":{"no_token":"You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.","send_instructions":"You will receive an email with instructions on how to reset your password in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.","updated":"Your password has been changed successfully. You are now signed in.","updated_not_active":"Your password has been changed successfully."},"registrations":{"destroyed":"Bye! Your account has been successfully cancelled. We hope to see you again soon.","signed_up":"Welcome! You have signed up successfully.","signed_up_but_inactive":"You have signed up successfully. However, we could not sign you in because your account is not yet activated.","signed_up_but_locked":"You have signed up successfully. However, we could not sign you in because your account is locked.","signed_up_but_unconfirmed":"A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.","update_needs_confirmation":"You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.","updated":"Your account has been updated successfully."},"sessions":{"signed_in":"","signed_out":"","already_signed_out":""},"unlocks":{"send_instructions":"You will receive an email with instructions for how to unlock your account in a few minutes.","send_paranoid_instructions":"If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.","unlocked":"Your account has been unlocked successfully. Please sign in to continue."}},"hello":"Hello world","header_menu":{"file":{"changeproject":"Create Project","adminproject":"Project Manager","file":"File","open":"Open","save":"Save","load":"Load","setting":"Setting","new_file":"New File","all_save":"Save all code"},"action":{"action":"Action","select_action":"(Select Action)","draw":{"draw":"Draw","arrow":"Arrow","button":"Button"},"preload_item":"Default items","added_item":"Added items","edit":"Edit","item_coding":"Create Item(For Dev)"},"motion_check":{"title":"Motion Check","newtab":"New Tab","newwindow":"Run with Window"},"page":{"page":"Page","add_page":"Add page","delete_page":"Remove page","fork":"Fork","add_fork":"Add fork","delete_fork":"Remove fork","master":"Upstream"},"etc":{"etc":"Etc","language":"Language","introduction":"introduction","about":"About","back_to_gallery":"Back to gallery","last_update_date":"Last update"},"setting":{"view_setting":"View setting","show_guide":"Toggle Guide","screen_size":"Change screen size"}},"context_menu":{"new_file":"New File","new_folder":"New Folder","js":"JavaScript","coffee":"CoffeeScript","copy":"Copy","cut":"Cut","paste":"Paste","float":"Float","rear":"Rear","delete":"Delete","edit":"Edit","preview":"Preview"},"config":{"tab":{"beginning_event_state":"Beginning State","worktable_setting":"Worktable Setting","item_state":"Item State"},"state":{"page_num":"Page number","page_select_option":"Page","page_select_option_none":"None(Finish)","finish_page":"Finish page","jump_to":"Jump to","background":"Background","screen_state":"First Screen State","screen_state_warn":"A point to notice that item's focus takes position priority."},"worktable_setting":{"display_position":"Display Position","zoom":"Zoom rate"},"select_opt_group":{"common":"Common Event","item":"Item"},"item_state":{"created_item_list":"Created item's list"},"event":{"action":{"action":"Action","preview":"Preview","stop_preview":"Stop previewing","keep_mag":"Keep display's magnification","apply":"Apply","common_state":"Change common state"},"kick":{"kick_type":"Action kick type","scroll":"Scroll","click":"Click","scroll_point":"Scroll value","scroll_direction":"Scroll direction","click_duration":"Click duration","fork":"Event fork"},"item_common":{"item_common":"Change item state","position":"Display position","show":"Display state","show_will_chapter":"Show as launched","show_will_chapter_duration":"Duration time","hide_did_chapter":"Hide as finished","hide_did_chapter_duration":"Duration time","size":"Item Size"},"item_state":{"item_state":"Item state","focus":"Focus"},"sync_before":"Sync with before","target_select":{"target_select":"Select event target","default":"(Select)"},"display_state":{"display_state":"Display state","applied_state":"Update display into events applied"}}},"gallery":{"bookmark_button":"Bookmark","input_note":"Comment..."},"upload_confirm":{"title":"Title name","caption":"Caption","tags":"Tags","popular_tags":"Popular tags","recommend_tags":"Recommend tags","version":"Version","show_guide":"Show Motion Guide","show_page_num":"Show Page Number","show_chapter_num":"Show Chapter Number","existed_upload_contents":"The project document which has been posted exists.","overwrite_contents":"Overwrite : %{contents}","posting_new":"Posting new document","thumbnail":"Thumbnail","thumbnail_warn":"Maximum thumbnail size is %{size}KB.","thumbnail_size_error":"This thumbnail size exceed %{size}KB.","title_input_error":"Required"},"mypage":{"header_title":{"bookmarks":"Your Bookmarks","created_contents":"Your written documents","created_items":"Your making items","using_items":"Now using items"},"empty":{"bookmarks_description":"There is no bookmarks","created_contents_description":"There is no written documents","created_items_description":"There is no made items","using_items_description":"There is no using items","bookmarks_link_description":"Don't want to check documents in gallery?","created_contents_link_description":"Don't want to write a document?","created_items_link_description":"Don't want to make a item?","using_items_link_description":"Don't want to use a made item?"},"message":{"default_delete_message":"This operation can't undo"}},"embed":{"caption":{"play_in_site":"Read in Sweetdoc"}},"message":{"dialog":{"change_project":"Your making contents will delete.","last_savetime":"Last saved time:","delete_item":"This item will delete.","update_gallery":"Upload","delete_node":"This contents (w/subtree) will delete.","delete_project":"This project will delete.","delete_event":"This event will delete.","delete_page":"This page will delete.","sample_project_upload":"Sample project can't upload to gallery.\nPlease write your own project.\n"},"database":{"item_state":{"save":{"success":"","error":""},"load":{"error":""}}},"gallery":{"upload":{"save":{"success":"","error":""}}},"project":{"error":{"project_name":"Project name not inputed.","display_size":"Display size not inputed.","not_exist":"Created project is nothing.","get_error":"Error"}}},"common_action":{"background":"Background","screen":"Screen"},"test":"testok","account":{"in_use_as_guest":"In use as guest","login_or_create_account":"Login or Create account","edit":"Edit account","logout":"Logout","continue_as_guest":"Continue as guest"},"modal":{"project_name":"Project name","display_size":"Display size","width":"Width","height":"Height","project_create":"Create","project_select":"Select","not_fix_screen_size":"Not fix screen size","fix_screen_size":"Fix screen size","select_project":"Select project","button":{"create":"Create","open":"Open","back":"Back to gallery"},"environment_not_support":"This browser is not under support.","not_sample_project":"Your projects","sample_project":"Sample projects"},"contents_info":{"page":"Page","fork":"Fork","chapter":"Chapter"},"user":{"sign_in":"Sign in to Sweetdoc","do_sign_in":"Sign in","sign_in_with_social":"Sign In with a Social Network","sign_up":"Create an account","do_sign_up":"Create","forgot_your_password":"Forgot your password?","edit_account":"Edit an account","cancel_account":"Cancel my account","update":"Update","send_me_reset_password_instructions":"Send me reset password instructions","resend_confirmation_instructions":"Resend confirmation instructions","do_resend_confirmation_instructions":"Resend"}},"ja":{"devise":{"confirmations":{"confirmed":"Your email address has been successfully confirmed.","send_instructions":"You will receive an email with instructions for how to confirm your email address in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes."},"failure":{"already_authenticated":"既にログインしています。","inactive":"アカウントが有効ではありません。","invalid":"%{authentication_keys} または password が一致しません。","locked":"アカウントはロックされています。","last_attempt":"You have one more attempt before your account is locked.","not_found_in_database":"%{authentication_keys} または password が一致しません。","timeout":"セッションが切れました。もう一度ログインしてください。","unauthenticated":"続けるにはアカウントのログインが必要です。","unconfirmed":"続けるにはアカウントのメール認証が必要です。"},"mailer":{"confirmation_instructions":{"subject":"Confirmation instructions"},"reset_password_instructions":{"subject":"Reset password instructions"},"unlock_instructions":{"subject":"Unlock instructions"}},"omniauth_callbacks":{"failure":"Could not authenticate you from %{kind} because \"%{reason}\".","success":"Successfully authenticated from %{kind} account."},"passwords":{"no_token":"You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.","send_instructions":"You will receive an email with instructions on how to reset your password in a few minutes.","send_paranoid_instructions":"If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.","updated":"Your password has been changed successfully. You are now signed in.","updated_not_active":"Your password has been changed successfully."},"registrations":{"destroyed":"Bye! Your account has been successfully cancelled. We hope to see you again soon.","signed_up":"アカウントを作成しました！","signed_up_but_inactive":"You have signed up successfully. However, we could not sign you in because your account is not yet activated.","signed_up_but_locked":"You have signed up successfully. However, we could not sign you in because your account is locked.","signed_up_but_unconfirmed":"A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.","update_needs_confirmation":"You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirm link to confirm your new email address.","updated":"Your account has been updated successfully."},"sessions":{"signed_in":"","signed_out":"","already_signed_out":""},"unlocks":{"send_instructions":"You will receive an email with instructions for how to unlock your account in a few minutes.","send_paranoid_instructions":"If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.","unlocked":"Your account has been unlocked successfully. Please sign in to continue."}},"errors":{"messages":{"already_confirmed":"was already confirmed, please try signing in","confirmation_period_expired":"needs to be confirmed within %{period}, please request a new one","expired":"has expired, please request a new one","not_found":"not found","not_locked":"was not locked","not_saved":{"one":"1 error prohibited this %{resource} from being saved:","other":"%{count} errors prohibited this %{resource} from being saved:"},"taken":"は既に使用されています。","blank":"が入力されていません。","too_short":"は%{count}文字以上に設定して下さい。","too_long":"は%{count}文字以下に設定して下さい。","invalid":"は有効でありません。","confirmation":"が内容とあっていません。"}},"hello":"こんにちは","header_menu":{"file":{"changeproject":"プロジェクト作成・読み込み","adminproject":"プロジェクト管理","file":"ファイル","open":"開く","save":"保存","load":"読み込み","setting":"設定","new_file":"新規ファイル","all_save":"全保存"},"action":{"action":"アクション","select_action":"(アクションを選択)","draw":{"draw":"描画","arrow":"矢印","button":"ボタン"},"preload_item":"標準アイテム","added_item":"追加アイテム","edit":"編集","item_coding":"アイテム作成(開発者向け)"},"motion_check":{"title":"動作確認","newtab":"新タブで実行","newwindow":"新ウィンドウで実行"},"page":{"page":"ページ","add_page":"ページ追加","delete_page":"ページ削除","fork":"フォーク","add_fork":"フォーク追加","delete_fork":"フォーク削除","master":"マスター"},"etc":{"etc":"その他","language":"言語","introduction":"自己紹介","about":"このサイトについて","back_to_gallery":"ギャラリーに戻る","last_update_date":"最新更新時間"},"setting":{"view_setting":"表示設定","show_guide":"モーションガイド表示/非表示","screen_size":"スクリーンサイズ変更"}},"context_menu":{"new_file":"新規ファイル","new_folder":"新規フォルダ","copy":"コピー","cut":"切り取り","paste":"貼り付け","float":"最前面に移動","rear":"再背面に移動","delete":"削除","edit":"編集","preview":"プレビュー"},"config":{"tab":{"beginning_event_state":"イベント開始状態","worktable_setting":"Worktable設定","item_state":"アイテム状態"},"state":{"page_num":"ページ番号","page_select_option":"ページ","page_select_option_none":"遷移なし(終了)","finish_page":"ページ終了","jump_to":"ページ遷移","background":"背景","screen_state":"画面初期表示状態","screen_state_warn":"アイテムのフォーカスが設定されている場合、画面初期位置はフォーカスが優先されます。"},"worktable_setting":{"display_position":"表示位置","zoom":"表示倍率"},"select_opt_group":{"common":"共通イベント","item":"アイテム"},"item_state":{"created_item_list":"作成アイテム一覧"},"event":{"action":{"action":"アクション","preview":"プレビュー","stop_preview":"プレビュー停止","keep_mag":"画面の表示倍率を保持","apply":"適用","common_state":"共通状態変更"},"kick":{"kick_type":"実行タイプ","scroll":"スクロール","click":"クリック","scroll_point":"スクロール値","scroll_direction":"スクロール方向","click_duration":"イベント実行時間","fork":"イベント分岐"},"item_common":{"item_common":"アイテム状態変更","position":"表示位置","show":"表示状態","show_will_chapter":"チャプター開始時に表示","show_will_chapter_duration":"実行時間","hide_did_chapter":"チャプター終了時に非表示","hide_did_chapter_duration":"実行時間","size":"アイテムサイズ"},"item_state":{"item_state":"アイテム状態","focus":"フォーカス"},"sync_before":"イベント同時実行","target_select":{"target_select":"イベント対象","default":"(未選択)"},"display_state":{"display_state":"表示状態","applied_state":"画面をイベント適用後に変更"}}},"gallery":{"bookmark_button":"ブックマークする","input_note":"コメントを入力"},"upload_confirm":{"title":"タイトル名","caption":"説明","tags":"タグ","popular_tags":"人気のタグ","recommend_tags":"おすすめのタグ","version":"バージョン","show_guide":"モーションガイドを表示","show_page_num":"ページ番号を表示","show_chapter_num":"チャプター番号を表示","existed_upload_contents":"このプロジェクトで作成された投稿済みドキュメントがあります","overwrite_contents":"%{contents} の更新","posting_new":"新規のドキュメントとして投稿","thumbnail":"サムネイル","thumbnail_warn":"設定可能なファイルサイズは%{size}KB以下です","thumbnail_size_error":"ファイルサイズが%{size}KBを超過しています","title_input_error":"タイトルを入力してください"},"mypage":{"header_title":{"bookmarks":"ブックマーク一覧","created_contents":"作成したドキュメント一覧","created_items":"作成したアイテム一覧","using_items":"使用中アイテム一覧"},"empty":{"bookmarks_description":"ブックマークがありません","created_contents_description":"作成したドキュメントはありません","created_items_description":"作成したアイテムはありません","using_items_description":"使用中のアイテムはありません","bookmarks_link_description":"ギャラリーに移動する","created_contents_link_description":"ドキュメントを作成する","created_items_link_description":"アイテムを作成する","using_items_link_description":"アイテムを使用する"},"message":{"default_delete_message":"削除してよろしいですか？"}},"embed":{"caption":{"play_in_site":"元サイトで閲覧"}},"message":{"dialog":{"change_project":"作成中のコンテンツは削除されます。","last_savetime":"最終保存時間:","delete_item":"アイテムを削除します。","update_gallery":"アップロードします。","delete_node":"ノードを削除します。 ノード以下のサブツリーも同時に削除されます。","delete_project":"プロジェクトを削除します。","delete_event":"イベントを削除します。","delete_page":"ページを削除します。","sample_project_upload":"このプロジェクトはサンプルのため\nアップロードは使用できません。\n"},"database":{"item_state":{"save":{"success":"アイテムの状態を保存しました。","error":"アイテムの保存に失敗しました。"},"load":{"success":"アイテムの状態を読み込みました。","error":"アイテムの読み込みに失敗しました。"}}},"gallery":{"upload":{"save":{"success":"","error":""}}},"project":{"error":{"project_name":"プロジェクト名が入力されていません。","display_size":"画面サイズが入力されていません。","not_exist":"作成済みのプロジェクトは存在しません。","get_error":"情報取得エラー"}}},"common_action":{"background":"背景","screen":"画面表示"},"activerecord":{"attributes":{"user":{"name":"名前","password":"パスワード","password_confirmation":"パスワード確認","email":"メールアドレス","remember_me":"セッションを保持"}}},"account":{"in_use_as_guest":"ゲストとして使用中","login_or_create_account":"ログインまたは新規作成","edit":"アカウント編集","logout":"ログアウト","continue_as_guest":"ゲストのまま継続"},"modal":{"project_name":"プロジェクト名","display_size":"サイズ","width":"幅","height":"高さ","project_create":"プロジェクト作成","project_select":"プロジェクト選択","not_fix_screen_size":"画面サイズ指定しない","fix_screen_size":"画面サイズ指定","select_project":"プロジェクト","button":{"create":"作成","open":"選択","back":"ギャラリーに戻る"},"environment_not_support":"お使いのブラウザは未対応です。","not_sample_project":"あなたのプロジェクト","sample_project":"サンプルプロジェクト"},"contents_info":{"page":"ページ","fork":"フォーク","chapter":"チャプター"},"user":{"sign_in":"SweetDocにログイン","do_sign_in":"ログイン","sign_in_with_social":"ソーシャルボタンでログイン","sign_up":"新規アカウントを作成","do_sign_up":"アカウント作成","forgot_your_password":"Forgot your password?","edit_account":"アカウント編集","cancel_account":"アカウント削除","update":"更新","send_me_reset_password_instructions":"パスワードリセットをリクエスト","resend_confirmation_instructions":"アカウント確認メールを再送信する","do_resend_confirmation_instructions":"再送信"}}};