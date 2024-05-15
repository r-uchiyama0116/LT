variable "access_key" {}             #アクセスキーの変数宣言
variable "secret_key" {}             #シークレットキーの変数宣言
variable "region" {                  #リージョンの変数宣言
  default = "ap-northeast-1"         #リージョンタイプ
}

provider "aws" {                     #プロバイダーをAWSに指定
  access_key = var.access_key        #TerraformのVariablesのkey(access_key)のValueが入力される
  secret_key = var.secret_key        #TerraformのVariablesのkey(secret_key)のValueが入力される
  region     = var.region            #本ライトニングトークではvar.regionの指定は行わない。上記で入力したdefaultが反映されているかを確認する。
}

resource "aws_security_group" "web-sg" {  #セキュリティグループの作成。icmp通信を0番から8番ポートですべて許可するというセキュリティグループになっています。
    name = "web-sg"                       #セキュリティグループの名前。好きな名前に書き換えてください
    ingress {                             #ingressの指定
    from_port = 0                         #0番ポートから8番ポートを対象とする
    to_port = 8
    protocol = "icmp"                     #セキュリティグループの対象プロトコルはicmp
    cidr_blocks = ["0.0.0.0/0"]           #CIDRブロックのリスト。0.0.0.0/0の場合何も制限しないです。
    }                                     
}

resource "aws_instance" "web" {                              #EC2インスタンスの指定
    ami           = "ami-0d0150aa305b7226d"                  #amiの指定。ここでは決め打ちでAmazonLinux2を利用するようにしています。
    instance_type = "t2.micro"                               #インスタンスタイプの指定。ここではt2.microを指定しています。
    security_groups = ["${aws_security_group.web-sg.name}"]  #セキュリティグループの結び付け。先ほど作成したセキュリティグループを紐づけています。
    tags = {
        Name = "ao-tanaka"                                   #ご自身の名前に変えてみましょう
    }
}
