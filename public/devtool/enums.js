// 预定义枚举配置文件
// 可以在这里添加常用的业务枚举定义

const PREDEFINED_ENUMS = {
    // 佣金来源
    'COMMISSION_SOURCE': {
        1: 'P1',
        2: 'P2',
        3: 'BRAND_IN_ADMIN',
        4: 'BRAND_IN_MSP',
        5: 'BRAND_IN_SC',
        7: 'FOOD'
    },

    // 佣金状态（前端显示）
    'COMMISSION_FE_STATUS': {
        0: 'UNKNOWN',
        1: 'UPCOMING',
        2: 'ONGOING',
        3: 'ENDED',
        4: 'TERMINATED',
        5: 'DRAFT',
        6: 'SUBMITTED',
        7: 'TERMINATED_SUBMITTED',
        8: 'PAUSED',
        9: 'PAUSED_SUBMITTED',
        10: 'FIRST_SUBMITTED',
        11: 'TERMINATING'
    },

    // 佣金数据库状态
    'COMMISSION_DB_STATUS': {
        0: 'NORMAL',
        1: 'DRAFT',
        2: 'TERMINATED',
        3: 'DELETED',
        4: 'PAUSED',
        5: 'TERMINATE_IN_PROGRESS'
    },

    // 佣金类型
    'COMMISSION_TYPE': {
        0: 'UNKNOWN',
        1: 'CATEGORY',
        2: 'ITEM',
        3: 'SHOP',
        4: 'PRODUCT_LABEL_OR_COLLECTION',
        5: 'SHOP_TAG',
        6: 'ITEM_TAG'
    },

    // 用户类型
    'USER_TYPE': {
        0: 'NONE',
        1: 'APP_NEW',
        2: 'APP_EXISTING',
        3: 'WEB_NEW',
        4: 'WEB_EXISTING'
    },

    // 产品类型
    'PRODUCT_TYPE': {
        0: 'NONE',
        1: 'MP',
        2: 'DP',
        3: 'FOOD'
    },

    // 产品范围
    'PRODUCT_SCOPE': {
        1: 'C2C_NON_CB',
        2: 'C2C_CB',
        4: 'SHOPEE_MALL_NON_CB',
        8: 'SHOPEE_MALL_CB',
        16: 'PREFERRED_SELLER_NON_CB',
        32: 'PREFERRED_SELLER_CB',
        64: 'SHOPEE_FOOD',
        128: 'SHOPEE_MART'
    },

    // 产品范围前端显示
    'PRODUCT_SCOPE_FE': {
        1: 'C2C_NON_CB_FE',
        2: 'C2C_CB_FE',
        3: 'SHOPEE_MALL_NON_CB_FE',
        4: 'SHOPEE_MALL_CB_FE',
        5: 'PREFERRED_SELLER_NON_CB_FE',
        6: 'PREFERRED_SELLER_CB_FE',
        7: 'SHOPEE_FOOD_FE',
        8: 'SHOPEE_MART_FE'
    },

    // 推客范围
    'AFFILIATE_SCOPE': {
        0: 'ALL',
        1: 'ONLY_BY_AFFILIATE',
        2: 'ONLY_BY_TAG',
        3: 'BOTH_BY_AFFILIATE_AND_TAG',
        4: 'BY_TARGET_TAG'
    },

    // 商店类型
    'SHOP_TYPE': {
        0: 'UNKNOWN',
        1: 'CB_SHOPEE_MALL',
        2: 'CB_C2C',
        3: 'CB_PREFER_SELLER',
        4: 'NONE_CB_SHOPEE_MALL',
        5: 'NON_CB_C2C',
        6: 'NON_CB_PREFER_SELLER'
    },

    // 商店活动状态
    'SHOP_CAMPAIGN_STATUS': {
        1: 'ALL',
        2: 'VALID',
        3: 'INVALID'
    },

    // 活动组
    'CAMPAIGN_GROUP': {
        1: 'SHOP_CAMPAIGN',
        2: 'TARGET_CAMPAIGN',
        3: 'OPEN_CAMPAIGN'
    },

    // 程序类型
    'PROGRAM_TYPE': {
        1: 'NORMAL_AFFILIATE',
        2: 'SELLER_AFFILIATE'
    },

    // 跟踪渠道来源
    'TRACKING_CHANNEL_SOURCE': {
        1: 'SOCIAL_MEDIA',
        2: 'SHOPEE_VIDEO',
        3: 'LIVE_STREAMING',
        4: 'UNTRACKED_SOURCE'
    },

    // 订单归因模型
    'ORDER_ATTRIBUTION_MODEL': {
        1: 'INDIRECT_CHECKOUT',
        2: 'DIRECT_SHOP',
        3: 'DIRECT_ITEM'
    },

    // 活动页面来源
    'CAMPAIGN_PAGE_SOURCE': {
        11: 'SELLER_CENTER',
        12: 'APP_WELCOME',
        13: 'APP_NORMAL'
    },

    // 品牌商店来源
    'BRAND_SHOP_SOURCE': {
        1: 'BRAND_IN_ADMIN',
        2: 'BRAND_IN_MSP',
        3: 'BRAND_IN_SELLER'
    },
};

// 导出枚举数据
if (typeof module !== 'undefined' && module.exports) {
    module.exports = PREDEFINED_ENUMS;
} else if (typeof window !== 'undefined') {
    window.PREDEFINED_ENUMS = PREDEFINED_ENUMS;
}