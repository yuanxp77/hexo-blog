// 预定义枚举配置文件
// 可以在这里添加常用的业务枚举定义

const PREDEFINED_ENUMS = {
    // 活动状态
    'CAMPAIGN_STATUS': {
        1: 'DRAFT',
        2: 'ACTIVE', 
        3: 'PAUSED',
        4: 'COMPLETED',
        5: 'CANCELLED'
    },
    
    // 用户状态
    'USER_STATUS': {
        0: 'INACTIVE',
        1: 'ACTIVE',
        2: 'SUSPENDED',
        3: 'DELETED'
    },
    
    // 订单状态
    'ORDER_STATUS': {
        1: 'PENDING',
        2: 'CONFIRMED',
        3: 'SHIPPED',
        4: 'DELIVERED',
        5: 'CANCELLED',
        6: 'REFUNDED'
    },
    
    // 支付状态
    'PAYMENT_STATUS': {
        0: 'PENDING',
        1: 'SUCCESS',
        2: 'FAILED',
        3: 'CANCELLED',
        4: 'REFUNDED'
    },
    
    // 商品类型
    'PRODUCT_TYPE': {
        1: 'PHYSICAL',
        2: 'DIGITAL',
        3: 'SERVICE',
        4: 'SUBSCRIPTION'
    },
    
    // 通知类型
    'NOTIFICATION_TYPE': {
        1: 'EMAIL',
        2: 'SMS',
        3: 'PUSH',
        4: 'IN_APP'
    },
    
    // 权限级别
    'PERMISSION_LEVEL': {
        0: 'NONE',
        1: 'READ',
        2: 'WRITE',
        3: 'ADMIN',
        4: 'SUPER_ADMIN'
    },
    
    // 性别
    'GENDER': {
        0: 'UNKNOWN',
        1: 'MALE',
        2: 'FEMALE',
        3: 'OTHER'
    },
    
    // 地区
    'REGION': {
        1: 'NORTH_AMERICA',
        2: 'SOUTH_AMERICA',
        3: 'EUROPE',
        4: 'ASIA',
        5: 'AFRICA',
        6: 'OCEANIA'
    },
    
    // 语言
    'LANGUAGE': {
        1: 'EN',
        2: 'ZH',
        3: 'ES',
        4: 'FR',
        5: 'DE',
        6: 'JA',
        7: 'KO'
    }
};

// 导出枚举数据
if (typeof module !== 'undefined' && module.exports) {
    module.exports = PREDEFINED_ENUMS;
} else if (typeof window !== 'undefined') {
    window.PREDEFINED_ENUMS = PREDEFINED_ENUMS;
}
