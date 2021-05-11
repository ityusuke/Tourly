# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include SessionsHelper
  #######################
  ## 定数管理
  #########################
  DEFAULT_SPOT_IMAGE="noImage.jpg"
  TOUR_TYPE_ARRAY=[{ "1": "一人で"}, { "2": "友達と" }, { "3": "恋人と" }, { "4": "家族と" }] 
  SPLIT_WITH_COMMA=","

  # フラッシュメッセージ
  FLASH_TOUR_NEW_SUCCESS='ツアーを登録しました'
  FLASH_TOUR_NEW_FAILED='ツアーの登録に失敗しました'
  FLASH_TOUR_EDIT_SUCCESS='ツアーを更新しました'
  FLASH_TOUR_EDIT_FAILED='ツアーの更新に失敗しました'
  FLASH_TOUR_DELETE_SUCCESS='ツアーを削除しました'

  FLASH_USER_NEW_SUCCESS='ユーザーを登録しました'
  FLASH_USER_NEW_FAILED='ユーザーの登録に失敗しました'
  FLASH_USER_EDIT_SUCCESS='ユーザーを更新しました'
  FLASH_USER_EDIT_FAILED='ユーザーの更新に失敗しました'
  FLASH_USER_DELETE_SUCCESS='ユーザーを削除しました'

  FLASH_USER_LOGIN_SUGGEST='ログインしてください'

  #検索機能
  def set_search
    @search = Tour.ransack(params[:q])
    @search_tours = @search.result.page(params[:page])
  end

#ログイン有無によるアクセス制限
  def check_user_login?
    unless current_user
      redirect_to root_path, notice: FLASH_USER_LOGIN_SUGGEST
    end
  end

end
