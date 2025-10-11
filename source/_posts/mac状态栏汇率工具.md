---
title: mac状态栏汇率工具
date: 2025-10-11 14:13:32
tags:
---

分享一个自己在用的查看实时货币汇率的mac小插件，是我用cursor写的，还算好用。

首先你需要安装一个工具，叫xbar，用于运行这个脚本。这是他们的官网：https://xbarapp.com

然后按教程使用我下面的脚本，就可以了，效果如图：

![demo.png](demo.png)

``` shell
#!/usr/bin/env bash
# <xbar.title>多币种汇率</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>yuanxp77</xbar.author>
# <xbar.author.github>yuanxp77</xbar.author.github>
# <xbar.desc>显示多种主流货币的人民币购汇价格，支持界面化配置</xbar.desc>
# <xbar.dependencies>shell,curl,bc</xbar.dependencies>

export PATH="/usr/local/bin:$PATH"
CONFIG_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.exchange-rates-config"
DEFAULT_MAIN_CURRENCIES="USD,HKD"

# 配置管理
load_config() { [ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE" || MAIN_CURRENCIES="$DEFAULT_MAIN_CURRENCIES"; }
save_config() { echo "MAIN_CURRENCIES=\"$MAIN_CURRENCIES\"" > "$CONFIG_FILE"; }
toggle_main_currency() {
    if [[ ",$MAIN_CURRENCIES," == *",$1,"* ]]; then
        MAIN_CURRENCIES=$(echo "$MAIN_CURRENCIES" | sed "s/,$1,/,/g" | sed "s/^$1,//g" | sed "s/,$1$//g" | sed "s/^$1$//g")
    else
        MAIN_CURRENCIES="${MAIN_CURRENCIES:+$MAIN_CURRENCIES,}$1"
    fi
    save_config
}
is_in_main() { [[ ",$MAIN_CURRENCIES," == *",$1,"* ]]; }

# 货币映射
get_currency_name() {
    case "$1" in
        "USD") echo "美元" ;; "EUR") echo "欧元" ;; "GBP") echo "英镑" ;; "JPY") echo "日元" ;; "HKD") echo "港币" ;; "AUD") echo "澳大利亚元" ;; "CAD") echo "加拿大元" ;; "CHF") echo "瑞士法郎" ;;
        "KRW") echo "韩国元" ;; "THB") echo "泰国铢" ;; "SGD") echo "新加坡元" ;; "NZD") echo "新西兰元" ;; "SEK") echo "瑞典克朗" ;; "NOK") echo "挪威克朗" ;; "DKK") echo "丹麦克朗" ;; "MXN") echo "墨西哥比索" ;;
        "ZAR") echo "南非兰特" ;; "INR") echo "印度卢比" ;; "MYR") echo "林吉特" ;; "PHP") echo "菲律宾比索" ;; "VND") echo "越南盾" ;; "CZK") echo "捷克克朗" ;; "HUF") echo "匈牙利福林" ;; "TRY") echo "土耳其里拉" ;;
        "ILS") echo "以色列谢克尔" ;; *) echo "$1" ;;
    esac
}
get_currency_symbol() {
    case "$1" in
        "USD") echo "$" ;; "EUR") echo "€" ;; "GBP") echo "£" ;; "JPY") echo "¥" ;; "HKD") echo "HK$" ;; "AUD") echo "AU$" ;; "CAD") echo "CA$" ;; "CHF") echo "CHF" ;;
        "KRW") echo "₩" ;; "THB") echo "฿" ;; "SGD") echo "S$" ;; "NZD") echo "NZ$" ;; "SEK") echo "kr" ;; "NOK") echo "kr" ;; "DKK") echo "kr" ;; "MXN") echo "MX$" ;;
        "ZAR") echo "R" ;; "INR") echo "₹" ;; "MYR") echo "RM" ;; "PHP") echo "₱" ;; "VND") echo "₫" ;; "CZK") echo "Kč" ;; "HUF") echo "Ft" ;; "TRY") echo "₺" ;;
        "ILS") echo "₪" ;; *) echo "$1" ;;
    esac
}

# 核心功能
get_exchange_rates() { curl -s -A "Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)" "https://www.boc.cn/sourcedb/whpj/index.html" --max-time 15; }
parse_currency_rate() {
    local rate_data=$(echo "$2" | grep -A 8 "<td>$1</td>" | grep -E "<td>[0-9.]+</td>" | sed 's/<[^>]*>//g' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
    [ ! -z "$rate_data" ] && echo "$(echo $rate_data | awk '{print $3}')"
}

# 主程序
[ "$1" = "toggle_main" ] && load_config && toggle_main_currency "$2" && exit 0
load_config
RESPONSE=$(get_exchange_rates)
[ $? -ne 0 ] || [ -z "$RESPONSE" ] && echo "❌ 网络错误" && exit 1

# 构建菜单栏显示
MAIN_DISPLAY_PARTS=""
IFS=',' read -ra MAIN_ARRAY <<< "$MAIN_CURRENCIES"
for code in "${MAIN_ARRAY[@]}"; do
    [ ! -z "$code" ] && rate=$(parse_currency_rate "$(get_currency_name "$code")" "$RESPONSE") && [ ! -z "$rate" ] && [ "$rate" != "0" ] && MAIN_DISPLAY_PARTS="${MAIN_DISPLAY_PARTS:+$MAIN_DISPLAY_PARTS }$(get_currency_symbol "$code")$rate"
done

echo "${MAIN_DISPLAY_PARTS:-💱 汇率}"
echo "---"

# 显示货币选择按钮
show_currency_buttons() {
    echo "$1 | size=12 color=#4A90E2"
    IFS=',' read -ra CURRENCY_ARRAY <<< "$2"
    for code in "${CURRENCY_ARRAY[@]}"; do
        [ ! -z "$code" ] && {
            currency_name=$(get_currency_name "$code")
            currency_symbol=$(get_currency_symbol "$code")
            rate=$(parse_currency_rate "$currency_name" "$RESPONSE")
            display_text="$currency_name ($currency_symbol)$([ ! -z "$rate" ] && [ "$rate" != "0" ] && echo " - $rate")"
            icon=$(is_in_main "$code" && echo "✅" || echo "⬜")
            echo "  $icon $display_text | bash='$0' param1=toggle_main param2=$code terminal=false refresh=true size=11"
        }
    done
}

show_currency_buttons "🌏 亚洲" "JPY,HKD,KRW,THB,SGD,MYR,PHP,INR,VND"
show_currency_buttons "🌍 欧美" "USD,EUR,GBP,CHF,SEK,NOK,DKK,CAD,MXN,CZK,HUF,TRY"
show_currency_buttons "🌍 其他" "ILS,AUD,NZD"

echo "---"
echo "100当地货币 = x人民币 | size=10 color=green"
echo "数据来源: 中国银行 $(date '+%H:%M:%S') | size=10 color=gray"
echo "刷新数据 | refresh=true"
```·