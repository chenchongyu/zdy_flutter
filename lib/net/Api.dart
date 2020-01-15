class Api {
  //static const String BaseUrl = "http://www.mocky.io/";
  static const String BaseUrl = "http://sjzx-kshzj-zhdy-1.cintcm.ac.cn:8080/";

  //描述：用户获取token
  //参数：unique（用户唯一标示）
  //返回：{"errorCode":"100","data":{"token":""}}
  static const String GET_TOKEN = "/api/center/login";

  //描述：获取推荐药列表
  //参数：text（查询内容）token(令牌)page（分页数）rows（行数）
  //返回：
  //  {
  //    "errorCode": "100",错误代码
  //    "data": {数据
  //    "recommedWords": [推荐症状
  //    "咽喉痛",
  //    ],
  //    "diseaseWords": [推荐病
  //    "感冒",
  //    ],
  //    "text": "发烧",查询词语
  //    "resultlist": {//查询出的中成药结果
  //    "gridModel": [
  //    {
  //    "medicinalId": "89325",药号
  //    "medicinalName": "感冒止咳冲剂",药名
  //    "medicinalSpecification": "每袋重10g(相当于总药材6g)",规格
  //    "medicinalIsInsurance": "医保",是否医保
  //    "medicinalContraindication": "尚不明确",用药禁忌
  //    "medicinalManufacturingEnterprise": "哈尔滨市康隆药业有限责任公司",药厂
  //    "medicinalEvaluateStar": "4",
  //    "medicinalRecommedKpi": "7",kpi
  //    "medicinalSaleCnt": "0",
  //    "medicinalDoubleEvaluateStar": "4.0",
  //    "medicinalViewCnt": "16"
  //    }
  //    ],
  //    "total": "580",
  //    "records": "1159",
  //    "page": "1"
  //    },
  //    "submitWords": [
  //    "发烧"
  //    ]
  //    }
  //  }
  static const String GET_RECOMMEND = "/api/v2/recommend/submitNew";

  //同上 这个接口要改造添加一个submitWords 用于第一层过滤 目前没改造
  static const String GET_RECOMMEND_FILTER = "/api/v2/recommend/filter";

  //获取疾病详情 api403
  static const String GET_DISEASE_DETAIL = "/api/v2/recommend/disease/detail";

  //查询查找药查询分类 api203
  static const String GET_SEARCH_TYPE_LIST = "/api/search/home";

  //查找药-查询结果 api204
  static const String GET_SEARCH_RESOULT = "/api/search/listNew";

  //个人中心.增加用户反馈 api101
  static const String ADD_FEEDBACK = "/api/center/feedback/add";

  //个人中心.推荐产品.产品列表 api102
  static const String GET_PRODUCT_LIST = "/api/center/recommend/product/list";

  //个人中心.推荐产品.产品详情 api103
  static const String GET_PRODUCT_DETAIL =
      "/api/center/recommend/product/detail";

  //个人中心.关于我们 api104
  static const String GET_ABOUT_US = "/api/center/about/us";

  //个人中心.获取最新版本信息(Android) api105
  static const String GET_VERSION = "/api/center/version";

  //个人中心.友情链接.链接列表 api106
  static const String GET_FRIEND_LINK_LIST = "/api/center/friend/link/list";

  //智能推荐.获取首页信息 api200
  static const String GET_RECOMMEND_HOME_INFO = "/api/recommend/home";

  //药品.药品说明书详情 api209
  static const String GET_MEDICINAL_DETAIL = "/api/medicinal/detail";

  //评价.获取待评价药品历史 api300
  static const String GET_EVALUATE_MEDICINAL_HISTORY =
      "/api/evaluate/medicinal/history";

  //评价.获取评价列表 api301
  static const String GET_EVALUATE_LIST = "/api/evaluate/list";

  //评价.加载评价页面数据 api302
  static const String GET_EVALUATE_PAGE = "/api/evaluate/page";

  //评价.新增一个评价 api303
  static const String ADD_EVALUATE = "/api/evaluate/add";

  //收藏.收藏列表 api304
  static const String GET_COLLECT_LIST = "/api/collect/list";

  //收藏.收藏一个药品 api305
  static const String ADD_COLLECT = "/api/collect/add";

  //收藏.取消收藏一个药品 api306
  static const String CANCEL_COLLECT = "/api/collect/cancel";

  ///获取验证码
  static const String GET_SMS_CODE = "/api/center/getSmsCode";

  ///注册
  static const String REGISTER = "/api/center/register";

  ///登录
  static const String SIGN_IN = "/api/center/signIn";

  ///用户信息
  static const String GET_USER_INFO = "/api/center/getUserInfo";

  ///商品列表
  static const String GET_GOODS_LIST = "/api/center/getGoodsList";

  ///历史订单
  static const String GET_ORDER_LIST = "/api/center/getOrderList";

  ///会员权益
  static const String GET_VIP_POWER_INFO = "/api/center/getVipPowerInfo";

  ///热搜词语
  static const String GET_HOT_WORD = "/api/center/hotword/list";

  ///获取订单号
  static const String GET_ORDER = "/api/center/getOrderNo";

  ///购买成功
  static const String UPDATE_ORDER = "/api/center/updateOrder";
}
