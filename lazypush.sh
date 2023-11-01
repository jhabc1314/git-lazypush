#! /bin/bash

# 定义颜色变量
RED='\e[1;31m' # 红
GREEN='\e[1;32m' # 绿
# YELLOW='\e[1;33m' # 黄
# BLUE='\e[1;34m' # 蓝
# PINK='\e[1;35m' # 粉红
RES='\e[0m' # 清除颜色

# 帮助函数
function help()
{
	echo -e "${GREEN}LazyPush 一个命令将 Git 分支提交合并到指定远程分支${RES}

Usage:
	chmod +x ./lazypush.sh	# 增加可执行权限

	./lazypush.sh <branchname> [comment]

The branchname are:

	head			使用当前所在分支
	branchname		指定需要提交的分支名, 例如 feature_1
	help			查看本帮助

The comment are:

	本次提交的注释说明, 不填默认 'fix'. 注释有空格时必须要引号包裹

Additional help:

	建议将 layzpush.sh 文件添加到 alias 中
	alias gg=/项目绝对路径/git-lazypush/lazypush.sh

示例:

	gg head '测试提交'	# commit当前所在分支, 合并到开发分支并push
"
}

function run_success()
{
	echo -e "\n ${GREEN}Success: $cmd ${RES}\n"
}

function run_fail () {
	echo -e "\n ${RED}Fail: $cmd ${RES}\n"
	exit
}

function git_checkout()
{
	local branch=$1
	cmd="git checkout $branch"
	if $cmd; then
		run_success
	else
		run_fail
	fi
}

function git_status()
{
	git status
	echo -e "\n${RED}确定提交且合并推送到远程测试分支 $remote_branch  吗？${RES}\n"
	echo "注意: 如有未被 git 跟踪的文件需要手动执行 git add 添加再重新执行命令"
	echo -e " 1 确定提交\n 2 再考虑考虑"
	echo "输入数字并回车"
	read -r choice
	if [ "$choice" != "1"  ]; then
		exit
	fi
}

function git_commit()
{
	local remark=$1
	if [ -z "$remark" ]; then
		remark="fix"
	fi

	cmd="git commit -am \"$remark\""
	if git commit -am "$remark"; then
		run_success
	else
		run_fail
	fi
}

function git_pull()
{
	local push_branch=$1
	cmd="git pull origin $push_branch"
	if $cmd; then
		run_success
	else
		run_fail
	fi
}

function git_merge()
{
	local branch=$1
	cmd="git merge $branch"
	if $cmd; then
		run_success
	else
		run_fail
	fi
}

function git_push()
{
	local push_branch=$1
	cmd="git push origin $push_branch"
	if $cmd; then
		run_success
	else 
		run_fail
	fi
}

function get_current_branch()
{
	git symbolic-ref --short -q HEAD
}

function confirm_branch()
{
	local current_branch=$1
	local err=$2
	if [ "$err" != "0"  ]
	then
		echo -e "${RED}请检查当前所在目录，未发现分支${RES}"
		exit
	else
		echo -e "\n ${RED}确定提交分支 $current_branch 吗？${RES}\n"
		echo -e " 1 提交 2 不提交\n输入并回车"
		read -r choice
		if [ "$choice" != "1" ]
		then
			exit
		fi

	fi
}

function get_remote_branch () {
	if [ -e "./.lazy_git" ]; then
		 # 配置文件取指定的分支名称
		 remote_branch=$(grep -E "\S" ./.lazy_git)
	else
		 # 没有配置文件时默认远端分支
		 remote_branch="develop"
	fi
}


# 1. 获取分支参数
branch=$1

if [[ -z $branch || $branch = "help" ]] 
then
	help

else	
	if [ "$branch" = 'head' ]
	then
		branch=$(get_current_branch)
		err=$?
		confirm_branch "$branch" $err
	fi
	# 2. 获取远端分支名
	get_remote_branch
	git_checkout "$branch"
	git_status
	git_commit "$2"
	git_checkout "$remote_branch"
	git_pull "$remote_branch"
	git_merge "$branch"
	git_push "$remote_branch"
	git_checkout "$branch"
	echo -e "${GREEN}操作成功!${RES}"
fi
