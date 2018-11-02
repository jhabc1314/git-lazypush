#! /bin/bash

readonly pushbranch="test" #默认推送到的测试分支名

# 帮助函数
function help()
{
	echo "###########################################
#             懒人提交大法                #
###########################################
#            author:jackdou               #
###########################################
# 格式：command param1 [param2]           #
# param1：需要合并提交到测试的分支名称    #
# param2：提交备注，不填默认为fix         #
# 举例：./lazypush.sh fixBug '修复bug'    #
# 建议：将lazypush.sh添加到别名例如 pp  #
# 优雅：pp fixBug '修复bug'               #
# 进阶：懒得写分支名?使用pp head [param2] #
# 即可提交项目的当前分支,一定要确认好哦   #
# 帮助：使用command help 查看本说明       #
###########################################"
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
	echo -e "\n确定提交并推送到远程测试分支 $pushbranch  吗？\n"
	echo "注意：如有未被git跟踪的文件需要手动执行git add添加再重新执行命令"
	echo -e " 1 确定提交\n 2 再考虑考虑"
	echo "输入并回车"
	read choice
	if [ "$choice" != "1"  ]
	then
		exit
	fi
}

git_commit()
{
	local remark=$1
	if [ -z $remark ]
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
		read choice
		if [ "$choice" != "1" ]
		then
			exit
		fi

	fi
}

#获取命令
branch=$1

if [[ -z $branch || $branch = "help" ]] 
then
	help

else	
	if [ $branch = 'head' ]
	then
		branch=$(get_current_branch)
		err=$?
		confirm_branch $branch $err
	fi
	git_checkout $branch
	git_status
	git_commit $2
	git_checkout $pushbranch
	git_pull $pushbranch
	git_merge $branch
	git_push $pushbranch
	git_checkout $branch
fi
