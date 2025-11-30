# Terragrunt構成ガイド

このドキュメントは、現在のTerraform構成をTerragruntに移行する際の設計書です。

## 目次

- [Terragrunt構成ガイド](#terragrunt構成ガイド)
  - [目次](#目次)
  - [現在の構成](#現在の構成)
    - [現在の問題点](#現在の問題点)
  - [Terragrunt変換後の構成](#terragrunt変換後の構成)

---

## 現在の構成

```
terraform-ci/
├── local.tf
├── README.md
├── .gitignore
├── env/
│   └── prod/
│       ├── main.tf
│       ├── variable.tf
│       ├── terraform.tfvars
│       └── terraform.tfstate
└── modules/
    ├── backend/
    │   ├── main.tf
    │   └── variable.tf
    └── codebuild/
        ├── main.tf
        ├── variable.tf
        └── iam.tf
```

### 現在の問題点

- 環境ごとにbackend設定を重複記述
- 共通設定の重複
- 環境追加時の手間
- モジュール間の依存関係を手動管理

---

## Terragrunt変換後の構成

```
terraform-ci/
├── terragrunt.hcl                      # ルート設定（全環境共通）
├── .gitignore
├── README.md
│
├── _envcommon/                         # 環境間共通設定
│   ├── backend.hcl                    # バックエンド共通設定
│   ├── codebuild.hcl                  # CodeBuild共通設定
│   └── common.hcl                     # 共通変数・タグ
│
├── modules/                            # Terraformモジュール（変更なし）
│   ├── backend/
│   │   ├── main.tf
│   │   ├── variable.tf
│   │   └── outputs.tf
│   └── codebuild/
│       ├── main.tf
│       ├── variable.tf
│       ├── iam.tf
│       └── outputs.tf
│
└── environments/                       # 環境別設定
    ├── prod/
    │   ├── terragrunt.hcl
    │   ├── account.hcl
    │   ├── region.hcl
    │   ├── backend/
    │   │   └── terragrunt.hcl
    │   └── codebuild/
    │       ├── terragrunt.hcl
    │       └── terraform.tfvars
    ├── staging/
    └── dev/
```
