# vpc-flow-log-s3
VPCフローログを生成しS3に転送する。  

<br />

## 実験
```
# サーバにSSH接続する。
$ ssh <EC2のグローバルIP>
protocol → 6、srcaddr → <接続元のグローバルIP>、action → ACCEPT ... が記録される。

# セキュリティグループでBlockされる通信はREJECTされる。
# 300番ポートが開いているかどうか通信を試みる。
$ telnet <EC2のグローバルIP> 300
protocol → 6、srcaddr → <接続元のグローバルIP>、action → REJECT ... が記録される。
```

<br />

## バケットポリシーについて
VPCフローログを有効化しS3にログを転送するためには、
`delivery.logs.amazonaws.com`が`s3:PutObject`と`s3:GetBucketAcl`する権限が必要。  
vpcフローログの有効化時にバケットポリシーが自動でアタッチされているようだ。   

<br />

## vpcフローログ生成後は`terraform destroy`でリソースが消せない

AWS CLI経由であれば、オブジェクトが存在してもバケットごと削除可能。  
(バケットでバージョニングが有効になっていない場合のみ)

```
$ aws s3 rb s3://bucket-name --force
```

<br />

## 参考
[VPC フローログを使用した IP トラフィックのログ記録](https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/flow-logs.html)

[VPC Flow Logsの出力先にS3が追加になって安価に使いやすくなりました](https://dev.classmethod.jp/articles/vpcflowlogs_to_s3/)

[各サービスから S3 へのログ出力が失敗している状態を検知してアラートを出してみた](https://dev.classmethod.jp/articles/catch-s3-delivery-log-put-error/)

[IANA Protocol Numbers](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml)
