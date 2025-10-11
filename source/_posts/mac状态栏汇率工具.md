---
title: mac状态栏汇率工具
date: 2025-10-11 14:13:32
tags:
---

分享一个自己在用的查看实时货币汇率的mac小插件，是我用cursor写的，还算好用。

首先你需要安装一个工具，叫xbar，这是他们的官网：https://xbarapp.com，用于运行这个脚本。

然后


``` shell
#!/usr/bin/env bash
#
# <xbar.title>多币种汇率</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>yuanxp77</xbar.author>
# <xbar.author.github>yuanxp77</xbar.author.github>
# <xbar.desc>显示多种主流货币的人民币购汇价格，支持界面化配置</xbar.desc>
# <xbar.dependencies>shell,curl,bc</xbar.dependencies>

export PATH="/usr/local/bin:$PATH"

# ========== 配置文件路径 ==========
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/.exchange-rates-config"

# ========== 配置说明 ==========
# 可用的货币代码:
# USD - 美元 ($)      EUR - 欧元 (€)      GBP - 英镑 (£)      JPY - 日元 (¥)
# HKD - 港币 (HK$)    AUD - 澳元 (AU$)    CAD - 加元 (CA$)    CHF - 瑞郎 (CHF)
# KRW - 韩元 (₩)      THB - 泰铢 (฿)      SGD - 新加坡元 (S$) NZD - 新西兰元 (NZ$)
# SEK - 瑞典克朗 (kr) NOK - 挪威克朗 (kr) DKK - 丹麦克朗 (kr) MXN - 墨西哥比索 (MX$)
# ZAR - 南非兰特 (R)  RUB - 俄罗斯卢布 (₽) BRL - 巴西雷亚尔 (R$) INR - 印度卢比 (₹)
# MYR - 马来西亚林吉特 (RM) PHP - 菲律宾比索 (₱)

# ========== 默认配置 ==========
DEFAULT_MAIN_CURRENCIES="THB,HKD"
DEFAULT_DETAIL_CURRENCIES="USD,EUR,GBP,JPY,HKD,AUD,CAD,CHF,KRW,THB,SGD,NZD,SEK,NOK,DKK,MXN,ZAR,RUB,BRL,INR,MYR,PHP"

# ========== 配置管理函数 ==========
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        MAIN_CURRENCIES="$DEFAULT_MAIN_CURRENCIES"
    fi
    # 详细信息货币始终使用默认配置
    DETAIL_CURRENCIES="$DEFAULT_DETAIL_CURRENCIES"
}

save_config() {
    cat > "$CONFIG_FILE" << EOF
MAIN_CURRENCIES="$MAIN_CURRENCIES"
EOF
}

toggle_main_currency() {
    local currency="$1"
    local current_main="$MAIN_CURRENCIES"
    
    if [[ ",$current_main," == *",$currency,"* ]]; then
        # 移除货币 - 使用更简单可靠的方法
        MAIN_CURRENCIES=$(echo "$current_main" | sed "s/,$currency,/,/g" | sed "s/^$currency,//g" | sed "s/,$currency$//g" | sed "s/^$currency$//g")
    else
        # 添加货币
        if [ -z "$MAIN_CURRENCIES" ]; then
            MAIN_CURRENCIES="$currency"
        else
            MAIN_CURRENCIES="$MAIN_CURRENCIES,$currency"
        fi
    fi
    save_config
}

is_in_main() {
    local currency="$1"
    [[ ",$MAIN_CURRENCIES," == *",$currency,"* ]]
}

# ========== 货币信息映射 ==========
get_currency_name() {
    case "$1" in
        "USD") echo "美元" ;;
        "EUR") echo "欧元" ;;
        "GBP") echo "英镑" ;;
        "JPY") echo "日元" ;;
        "HKD") echo "港币" ;;
        "AUD") echo "澳大利亚元" ;;
        "CAD") echo "加拿大元" ;;
        "CHF") echo "瑞士法郎" ;;
        "KRW") echo "韩国元" ;;
        "THB") echo "泰国铢" ;;
        "SGD") echo "新加坡元" ;;
        "NZD") echo "新西兰元" ;;
        "SEK") echo "瑞典克朗" ;;
        "NOK") echo "挪威克朗" ;;
        "DKK") echo "丹麦克朗" ;;
        "MXN") echo "墨西哥比索" ;;
        "ZAR") echo "南非兰特" ;;
        "RUB") echo "俄罗斯卢布" ;;
        "BRL") echo "巴西雷亚尔" ;;
        "INR") echo "印度卢比" ;;
        "MYR") echo "林吉特" ;;
        "PHP") echo "菲律宾比索" ;;
        *) echo "$1" ;;
    esac
}

get_currency_symbol() {
    case "$1" in
        "USD") echo "$" ;;
        "EUR") echo "€" ;;
        "GBP") echo "£" ;;
        "JPY") echo "¥" ;;
        "HKD") echo "HK$" ;;
        "AUD") echo "AU$" ;;
        "CAD") echo "CA$" ;;
        "CHF") echo "CHF" ;;
        "KRW") echo "₩" ;;
        "THB") echo "฿" ;;
        "SGD") echo "S$" ;;
        "NZD") echo "NZ$" ;;
        "SEK") echo "kr" ;;
        "NOK") echo "kr" ;;
        "DKK") echo "kr" ;;
        "MXN") echo "MX$" ;;
        "ZAR") echo "R" ;;
        "RUB") echo "₽" ;;
        "BRL") echo "R$" ;;
        "INR") echo "₹" ;;
        "MYR") echo "RM" ;;
        "PHP") echo "₱" ;;
        *) echo "$1" ;;
    esac
}

# ========== 核心功能函数 ==========
get_exchange_rates() {
    curl -s -A "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)" \
         "https://www.boc.cn/sourcedb/whpj/index.html" --max-time 15
}

parse_currency_rate() {
    local currency_name="$1"
    local response="$2"
    
    local rate_data=$(echo "$response" | grep -A 8 "<td>$currency_name</td>" | \
                     grep -E "<td>[0-9.]+</td>" | \
                     sed 's/<[^>]*>//g' | \
                     sed 's/^[[:space:]]*//' | \
                     sed 's/[[:space:]]*$//')
    
    if [ ! -z "$rate_data" ]; then
        local rate_array=($rate_data)
        echo "${rate_array[2]}"  # 银行卖出价
    fi
}

# ========== 主程序执行 ==========

# 处理配置参数
if [ "$1" = "toggle_main" ]; then
    load_config
    toggle_main_currency "$2"
    exit 0
fi

# 加载配置
load_config

# 获取汇率数据
RESPONSE=$(get_exchange_rates)

if [ $? -ne 0 ] || [ -z "$RESPONSE" ]; then
    echo "❌ 网络错误"
    exit 1
fi

# 构建菜单栏显示
MAIN_DISPLAY_PARTS=""
IFS=',' read -ra MAIN_ARRAY <<< "$MAIN_CURRENCIES"
for code in "${MAIN_ARRAY[@]}"; do
    if [ ! -z "$code" ]; then
        currency_name=$(get_currency_name "$code")
        currency_symbol=$(get_currency_symbol "$code")
        rate=$(parse_currency_rate "$currency_name" "$RESPONSE")
        
        if [ ! -z "$rate" ] && [ "$rate" != "0" ]; then
            if [ ! -z "$MAIN_DISPLAY_PARTS" ]; then
                MAIN_DISPLAY_PARTS="$MAIN_DISPLAY_PARTS "
            fi
            MAIN_DISPLAY_PARTS="$MAIN_DISPLAY_PARTS${currency_symbol}${rate}"
        fi
    fi
done

# 显示主要信息
if [ ! -z "$MAIN_DISPLAY_PARTS" ]; then
    echo "$MAIN_DISPLAY_PARTS"
else
    echo "💱 汇率"
fi

echo "---"

# 显示详细信息 - 分组展示
show_currency_group() {
    local group_name="$1"
    local currencies="$2"
    
    echo "$group_name | size=13 color=#4A90E2"
    
    local currency_data=()
    IFS=',' read -ra CURRENCY_ARRAY <<< "$currencies"
    
    # 收集所有有效汇率数据
    for code in "${CURRENCY_ARRAY[@]}"; do
        if [ ! -z "$code" ]; then
            currency_name=$(get_currency_name "$code")
            currency_symbol=$(get_currency_symbol "$code")
            rate=$(parse_currency_rate "$currency_name" "$RESPONSE")
            
            if [ ! -z "$rate" ] && [ "$rate" != "0" ]; then
                # 简化格式，避免复杂对齐
                local formatted_info="$currency_name 100$currency_symbol=$rate¥"
                currency_data+=("$formatted_info")
            fi
        fi
    done
    
    # 紧凑模式：每行显示2种货币，简化对齐
    for ((i=0; i<${#currency_data[@]}; i+=2)); do
        local first_item="${currency_data[i]}"
        
        if [ $((i+1)) -lt ${#currency_data[@]} ]; then
            local second_item="${currency_data[i+1]}"
            # 使用制表符和固定宽度来对齐
            local line_content=$(printf "%-25s %s" "$first_item" "$second_item")
            echo "$line_content | size=11 font=Menlo"
        else
            echo "$first_item | size=11 font=Menlo"
        fi
    done
}

# 主要发达国家货币
show_currency_group "💰 主要货币" "USD,EUR,GBP,JPY,CHF"

# 亚太地区货币  
show_currency_group "🌏 亚太地区" "HKD,KRW,THB,SGD,AUD,NZD,MYR,PHP,INR"

# 北欧货币
show_currency_group "🇪🇺 北欧货币" "SEK,NOK,DKK"

# 美洲货币
show_currency_group "🌎 美洲货币" "CAD,MXN,BRL"

# 其他货币
show_currency_group "🌍 其他货币" "ZAR,RUB"

echo "---"
echo "📱 菜单栏显示"

# 按组显示货币选择按钮
show_currency_buttons() {
    local group_name="$1"
    local currencies="$2"
    
    echo "$group_name | size=12 color=#4A90E2"
    
    IFS=',' read -ra CURRENCY_ARRAY <<< "$currencies"
    
    for code in "${CURRENCY_ARRAY[@]}"; do
        if [ ! -z "$code" ]; then
            currency_name=$(get_currency_name "$code")
            currency_symbol=$(get_currency_symbol "$code")
            
            if is_in_main "$code"; then
                echo "  ✅ $currency_name ($currency_symbol) | bash='$0' param1=toggle_main param2=$code terminal=false refresh=true size=11"
            else
                echo "  ⬜ $currency_name ($currency_symbol) | bash='$0' param1=toggle_main param2=$code terminal=false refresh=true size=11"
            fi
        fi
    done
}

# 分组显示货币选择按钮
show_currency_buttons "💰 主要货币" "USD,EUR,GBP,JPY,CHF"
show_currency_buttons "🌏 亚太地区" "HKD,KRW,THB,SGD,AUD,NZD"
show_currency_buttons "🇪🇺 北欧货币" "SEK,NOK,DKK"
show_currency_buttons "🌎 美洲货币" "CAD,MXN,BRL"
show_currency_buttons "🌍 其他货币" "ZAR,RUB,MYR,PHP,INR"

# 底部信息
echo "---"
echo "数据来源: 中国银行 | size=10 color=gray"
echo "更新时间: $(date '+%H:%M:%S') | size=10 color=gray"
echo "刷新数据 | refresh=true"

```