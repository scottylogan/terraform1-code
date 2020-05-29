# Terraform Tutorial

This is a short tutorial on using Terraform with AWS. It assumes some basic knowledge of Terraform.

# Requirements

You'll need an [Amazon Web Services account][https:/aws.amazon.com/), the [AWS CLI](https://aws.amazon.com/cli/), [Git](https://git-scm.com/), and [Terraform](https://terraform.io/).

You'll also need something to edit Terraform files, preferably with some syntax highlighting, etc. Some plugins / modes / extensions for common editors:

* [Atom](https://atom.io/packages/language-terraform)
* [Emacs](https://melpa.org/#/terraform-mode)
* [JetBrains Editors](https://plugins.jetbrains.com/plugin/7808-hashicorp-terraform--hcl-language-support) (IntelliJ IDEA, PyCharm, WebStorm, PhpStorm, etc.)
* [Nano](https://github.com/scopatz/nanorc)
* [Sublime Text 3](https://packagecontrol.io/packages/Terraform)
* [TextMate](https://github.com/aurynn/Terraform.tmbundle)
* [VIM](https://github.com/hashivim/vim-terraform)
* [Visual Studio Code](https://github.com/hashicorp/vscode-terraform)


# Tools Setup

You'll need to install some tools before starting this tutorial:

* `aws` - the Amazon command line client is useful for configuring AWS profiles, credentials, and options
* `git` - version (source code) tool
* `jq` - command line JSON tool
* `terraform` - command line tool for managing infrastructure resources

## Mac Setup

* Install [Homebrew](https://brew.sh)
* Use Homebrew to install Terraform, the AWS CLI, jq, and a newer version of git
```bash
% brew update
% brew install awscli git jq terraform
```

## Linux Setup

1. Install curl, git, groff, jq, pip3 (Python3), and unzip
   * APT based
   ```bash
   % sudo apt-get update
   % sudo apt-get install curl git groff jq python3-pip unzip
   ```

   * YUM based
   ```bash
   % sudo yum update
   % sudo yum install curl git groff-base jq python3-pip unzip
   ```

   * Alpine
   ```bash
   % sudo apk update
   % sudo apk add curl git groff jq python3 unzip
   ```

2. Install the AWS CLI
   ```bash
   % sudo pip3 install awscli
   ```
3. Install Terraform
   * Find the latest version of [Terraform](https://www.terraform.io/downloads.html) (You most likely wil  want the Linux 64-bit download)
   ```bash
   % cd /usr/local/bin
   % curl -so /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
   % sudo unzip /tmp/terraform.zip
   % rm /tmp/terraform.zip
   ```

### Windows Setup

I rarely use Windows, but here are some starting points

* [GUI](https://git-scm.com/download/gui/windows) or [CLI](https://git-scm.com/downloads) Git client
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-windows.html)
* [Terraform](https://www.terraform.io/downloads.html)
* [jq](https://stedolan.github.io/jq/)

<br/>


# AWS Setup

You should create a Terraform [IAM User](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html) in your AWS account, and grant that user full admin rights. This video shows the steps to take in the AWS Console  to create a new IAM user with credentials and the correct policy:

1. Create new IAM user (called `terraform`)
2. Attach the _AdministratorAccess_ policy to the user
3. Create and download credentials for the user

<br/>

[<img src="http://img.youtube.com/vi/vhEH8_Man3U/maxresdefault.jpg" alt="Watch the Video" width="50%" />](https://youtu.be/vhEH8_Man3U)


<br/>
