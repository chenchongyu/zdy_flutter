class Api {
  //static const String BaseUrl = "http://www.mocky.io/";
  static const String BaseUrl = "http://sjzx-kshzj-zhdy-1.cintcm.ac.cn:8080/";

  //描述：用户获取token
  //参数：unique（用户唯一标示）
  //返回：{"errorCode":"100","data":{"token":""}}
  static const String GET_TOKEN = BaseUrl + "/api/center/login";

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
  static const String GET_RECOMMEND = BaseUrl + "/api/v2/recommend/submit";
  //同上 这个接口要改造添加一个submitWords 用于第一层过滤 目前没改造
  static const String GET_RECOMMEND_FILTER =
      BaseUrl + "/api/v2/recommend/filter";
}
