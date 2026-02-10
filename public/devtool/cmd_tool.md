spkit gen gas-spex && rm -rf ./.git/hooks/
spkit build --no-hook -H
export GOEXPERIMENT=arenas && spkit build --no-hook
export GOEXPERIMENT=arenas && spkit build mod/commission_setting --no-hook

spcli proto publish span_61779 commissionsetting.proto -n affiliateplatform.commissionsetting -f
spcli proto publish span_61779 commissionsetting.proto -n affiliateplatform.commissionsetting -f
spcli proto publish span_61779 selector.proto -n affiliateplatform.commissionruleselector -f
spcli proto publish span_61779 selector.proto -n affiliateplatform.commissionruleselector -f

CID=ID;ENV=TEST;cid=id;env=test;SP_UNIX_SOCKET=/tmp/spex.sock;GOEXPERIMENT=arenas;PFB_NAME=pfb-yxpdev
CID=ID;ENV=TEST;cid=id;env=test;SP_UNIX_SOCKET=/tmp/spex.sock;PFB_NAME=pfb-yxpdev

;PORT_computerservicev2=8080

lsof -i :9088
kill 12345
kill -9 9088

rm -f /tmp/spex.sock && socat -d -d -d UNIX-LISTEN:/tmp/spex.sock,reuseaddr,fork TCP:agent-tcp.spex.test.shopee.io:9299

【修复情况】
完全修复

【问题原因】
查询max cap时，比较的初始值是0，且判断条件是大于>，capValue也为0时，则相当于略过该记录，无法正常取到max cap，返回空response。

【解决方案】
取max cap条件判断时，判断条件改为大于等于>=

【影响范围】
当前版本，设置cap值为0的场景

【gitlab地址】
[https://git.garena.com/shopee/marketing/affiliate/commission-plan/-/merge_requests/1779/diffs](https://git.garena.com/shopee/marketing/affiliate/commission-plan/-/merge_requests/1779/diffs)

【自测情况】
通过

apt install redis
redis-cli -h yy9mx.elasticredis.cloud.shopee.io -p 10582  -a  cache_readwrite_150080@zeJ1cL4H
redis-cli -h y91g9.elasticredis.cloud.shopee.io -p 10102
unlink affl:live:sg:commStatusDelayedQ:0

查找服务
smc -e `<env>` services ls

进入容器
smc -e `<env>` services enter `<container-name>`

查看容器日志
smc -e `<env>` services logs `<container-name>`

从服务器上下载文件
smc -e `<env>` services download `<container-name>` -s <src_dir> -d <dest_dir>

服务器上执行指令
smc -e `<env>` services run `<container-name>` '`<CMD>`'

进入sgw nginx
smc -e test services enter nginx-lb-test-sg/smc -e live services enter nginx-lb-live-sg

commission-plan canal消费
func setupCanalDataBusHandler() *canal.CanalDataBusHandler {
