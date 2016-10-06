require 'gs2/core/AbstractClient.rb'

module Gs2 module Timer
  
  # GS2-Timer クライアント
  #
  # @author Game Server Services, Inc.
  class Client < Gs2::Core::AbstractClient
  
    @@ENDPOINT = 'timer'
  
    # コンストラクタ
    # 
    # @param region [String] リージョン名
    # @param gs2_client_id [String] GSIクライアントID
    # @param gs2_client_secret [String] GSIクライアントシークレット
    def initialize(region, gs2_client_id, gs2_client_secret)
      super(region, gs2_client_id, gs2_client_secret)
    end
    
    # デバッグ用。通常利用する必要はありません。
    def self.ENDPOINT(v = nil)
      if v
        @@ENDPOINT = v
      else
        return @@ENDPOINT
      end
    end

    # タイマープールリストを取得。
    # 
    # @param pageToken [String] ページトークン
    # @param limit [Integer] 取得件数
    # @return [Array] 
    #  * items
    #    [Array]
    #      * timerPoolId => タイマープールID
    #      * ownerId => オーナーID
    #      * name => タイマープール名
    #      * description => 説明文
    #      * createAt => 作成日時
    #  * nextPageToken => 次ページトークン
    def describe_timer_pool(pageToken = nil, limit = nil)
      query = {}
      if pageToken; query['pageToken'] = pageToken end
      if limit; query['limit'] = limit end
      return get(
        'Gs2Timer', 
        'DescribeTimerPool',
        @@ENDPOINT,
        '/timerPool',
        query)
    end
 
    # タイマープールを作成。<br>
    # <br>
    # GS2-Timer を利用するには、まずタイマープールを作成する必要があります。<br>
    # タイマープールには複数のタイマーを格納することができます。<br>
    # 
    # @param request [Array]
    #  * name => タイマープール名
    #  * description => 説明文
    # @return [Array]
    #  * item
    #    * timerPoolId => タイマープールID
    #    * ownerId => オーナーID
    #    * name => タイマープール名
    #    * description => 説明文
    #    * createAt => 作成日時
    def create_timer_pool(request)
      body = {}
      if not request; raise ArgumentError.new() end
      if request.has_key?('name'); body['name'] = request['name'] end
      if request.has_key?('description'); body['description'] = request['description'] end
      return post(
        'Gs2Timer', 
        'CreateTimerPool',
        @@ENDPOINT,
        '/timerPool',
        body)
    end

    # タイマープールを更新。<br>
    # 
    # @param request [Array]
    #  * timerPoolName => タイマープール名
    #  * description => 説明文
    # @return [Array]
    #  * item
    #    * timerPoolId => タイマープールID
    #    * ownerId => オーナーID
    #    * name => タイマープール名
    #    * description => 説明文
    #    * createAt => 作成日時
    def update_timer_pool(request)
      body = {}
      if not request; raise ArgumentError.new() end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new() end
      if request.has_key?('description'); body['description'] = request['description'] end
      return put(
        'Gs2Timer', 
        'UpdateTimerPool',
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'],
        body)
    end
 
    # タイマープールを取得
    # 
    # @param request [Array]
    #  * timerPoolName => タイマープール名
    # @return [Array]
    #  * item
    #   * timerPoolId => タイマープールID
    #   * ownerId => オーナーID
    #   * name => タイマープール名
    #   * description => 説明文
    #   * createAt => 作成日時
    def get_timer_pool(request)
      if not request; raise ArgumentError.new() end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new() end
      if request['timerPoolName'] == nil; raise ArgumentError.new() end
      return get(
        'Gs2Timer', 
        'GetTimerPool',
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'])
    end
 
    # タイマープールを削除
    # 
    # @param request [Array]
    #  * timerPoolName => タイマープール名
    def delete_timer_pool(request)
      if not request; raise ArgumentError.new() end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new() end
      if request['timerPoolName'] == nil; raise ArgumentError.new() end
      return delete(
        'Gs2Timer', 
        'DeleteTimerPool',
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'])
    end
 
    # タイマーリストを取得
    # 
    # @param request [Array]
    # * timerPoolName => タイマープール名
    # @param string $pageToken ページトークン
    # @param integer $limit 取得件数
    # @return [Array]
    #  * items
    #    [Array]
    #      * timerId => タイマーID
    #      * timerPoolId => タイマープールID
    #      * ownerId => オーナーID
    #      * callbackMethod => HTTPメソッド
    #      * callbackUrl => コールバックURL
    #      * callbackBody => コールバックボディ
    #      * executeTime => 実行時間
    #      * retryMax => 最大リトライ回数
    #      * createAt => 作成日時
    #  * nextPageToken => 次ページトークン
    def describe_timer(request, pageToken = nil, limit = nil)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new(); end
      if request['timerPoolName'] == nil; raise ArgumentError.new(); end
      query = {}
      if pageToken; query['pageToken'] = pageToken; end
      if limit; query['limit'] = limit; end
      return get(
        'Gs2Timer', 
        'DescribeTimer', 
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'] + '/timer',
        query)
    end
 
    # タイマーを作成<br>
    # <br>
    # タイマーを作成すると、指定した時刻に指定したURLに指定したパラメータを持ったアクセスを発生させます。<br>
    # 基本的には指定した時刻以降に60秒以内に呼び出し処理が開始されます。<br>
    # 混雑時には60秒以上かかることがありますので、タイミングがシビアな処理には向きません。<br>
    # <br>
    # アカウントBANを指定した時刻付近で解除する。など、タイミングがシビアでない処理で利用することをおすすめします。<br>
    # 
    # @param request [Array]
    #  * callbackMethod => HTTPメソッド
    #  * callbackUrl => コールバックURL
    #  * callbackBody => コールバックボディ
    #  * executeTime => 実行時間
    #  * retryMax => 最大リトライ回数(OPTIONAL)
    # @return [Array]
    #  * item
    #   * timerId => タイマーID
    #   * timerPoolId => タイマープールID
    #   * ownerId => オーナーID
    #   * callbackMethod => HTTPメソッド
    #   * callbackUrl => コールバックURL
    #   * callbackBody => コールバックボディ
    #   * executeTime => 実行時間
    #   * retryMax => 最大リトライ回数
    #   * createAt => 作成日時
    def create_timer(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new(); end
      if request['timerPoolName'] == nil; raise ArgumentError.new(); end
      body = {};
      if request.has_key?('callbackMethod'); body['callbackMethod'] = request['callbackMethod']; end
      if request.has_key?('callbackUrl'); body['callbackUrl'] = request['callbackUrl']; end
      if request.has_key?('executeTime'); body['executeTime'] = request['executeTime']; end
      if request.has_key?('retryMax'); body['retryMax'] = request['retryMax']; end
      query = {}
      return post(
        'Gs2Timer', 
        'CreateTimer', 
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'] + '/timer',
        body,
        query)
    end
 
    # タイマーを取得
    # 
    # @param request [Array]
    # * timerPoolName => タイマープール名
    # * timerId => タイマーID
    # @return [Array]
    #  * item
    #   * timerId => タイマーID
    #   * timerPoolId => タイマープールID
    #   * ownerId => オーナーID
    #   * callbackMethod => HTTPメソッド
    #   * callbackUrl => コールバックURL
    #   * callbackBody => コールバックボディ
    #   * executeTime => 実行時間
    #   * retryMax => 最大リトライ回数
    #   * createAt => 作成日時
    def get_timer(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new(); end
      if request['timerPoolName'] == nil; raise ArgumentError.new(); end
      if not request.has_key?('timerId'); raise ArgumentError.new(); end
      if request['timerId'] == nil; raise ArgumentError.new(); end
      query = {}
      return get(
        'Gs2Timer',
        'GetTimer',
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'] + '/timer/' + request['timerId'],
        query)
    end
 
    # タイマーを削除
    # 
    # @param request [Array]
    #  * timerPoolName => タイマープール名
    #  * timerId => タイマーID
    def delete_timer(request)
      if not request; raise ArgumentError.new(); end
      if not request.has_key?('timerPoolName'); raise ArgumentError.new(); end
      if request['timerPoolName'] == nil; raise ArgumentError.new(); end
      if not request.has_key?('timerId'); raise ArgumentError.new(); end
      if request['timerId'] == nil; raise ArgumentError.new(); end
      query = {}
      return delete(
        'Gs2Timer', 
        'DeleteTimer', 
        @@ENDPOINT,
        '/timerPool/' + request['timerPoolName'] + '/timer/' + request['timerId'],
        query)
    end
  end
end end