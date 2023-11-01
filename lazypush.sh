#! /bin/bash

# 帮助函数
function help()
{
	echo "LazyPush 一个命令将 Git 分支提交合并到指定远程分支

Usage:
	chmod +x ./lazypush.sh	# 增加可执行权限

	./lazypush.sh <branchname> [comment]

The branchname are:

	head			使用当前所在分支
	branchname		指定需要提交的分支名, 例如 feature_1
	help			查看本帮助

The comment are:

	本次提交的说明, 不填默认 'fix'

Additional help:

	建议将 layzpush.sh 文件添加到 alias 中
	alias gg=/项目绝对路径/git-lazypush/lazypush.sh

示例:

	gg head '测试提交'
"
}

git_run()
{
	$cmd
	if [ $? == 0 ]
	then
		echo -e "\n success --- $cmd\n"
	else
		echo -e "\n fail --- $cmd\n"
		exit
	fi	

}

git_checkout()
{
	local branch=$1
	cmd="git checkout $branch"
	git_run 
}

git_status()
{
	git status
	echo -e "\n确定提交且合并推送到远程测试分支 $remote_branch  吗？\n"
	echo "注意: 如有未被 git 跟踪的文件需要手动执行 git add 添加再重新执行命令"
	echo -e " 1 确定提交\n 2 再考虑考虑"
	echo "输入并回车"
	read -r choice
	if [ "$choice" != "1"  ]
	then
		exit
	fi
}

git_commit()
{
	local remark=$1
	if [ -z "$remark" ]
	then
		remark="fix"
	fi

	cmd="git commit -a -m $remark"
	git_run 
}

git_pull()
{
	local push_branch=$1
	cmd="git pull origin $push_branch"
	git_run 
}

git_merge()
{
	local branch=$1
	cmd="git merge $branch"
	git_run 
}

git_push()
{
	local push_branch=$1
	cmd="git push origin $push_branch"
	git_run 
}

get_current_branch()
{
	git symbolic-ref --short -q HEAD
}

confirm_branch()
{
	local current_branch=$1
	local err=$2
	if [ "$err" != "0"  ]
	then
		echo "请检查当前所在目录，未发现分支"
		exit
	else
		echo -e "\n 确定提交分支 $current_branch 吗？\n"
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
fi
