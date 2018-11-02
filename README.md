# git-lazypush
lazy push branch to origin test branch

## 介绍（introduction）
1. `git` 懒人提交大法
2. 如果你的提交代码测试流程如下：

    . 创建开发分支 `dev`

    . 狂写一堆 `bug` 后提交 `dev` 分支（`git commit -a -m "写bug"`）

    . 切换（`checkout`）到 本地测试分支 `test`（`git checkout test`）

    . 合并开发分支（`git merge dev`）

    . 推送测试分支到远程（`git push origin test`）

3. 如果满足以上开发流程那么你有没有为每次的 `checkout` , `commit` , `push` 感到无聊呢？ 
4. 懒人提交正是整合了这些提交步骤，让你可以一个命令完成以上所有步骤的操作

## 使用方法（How To Use）

### Linux

1. 克隆本仓库代码到本地仓库 例如本地仓库路径为 `～/git-lazypush`

2. 默认的远程测试分支名称为 `test`，如果不一样需要修改 `~/git-lazypush/lazypush.sh` 文件的第三行的分支名称

3. 进入到需要提交的 `git` 分支目录

4. 执行命令 `～/git-lazypush/lazypush.sh head`

5. 按照提示确认是否提交仓库代码

```
可以将 ～/git-lazypush/lazypush.sh 添加为 别名 alias
例如 alias pp='～/git-lazypush/lazypush.sh'
这样 pp head 即可提交当前所在分支到远程分支
```

### Windows

1. 确保系统安装了 `git` 并且有 `git bash`，可以右键查看是否有 `git bash here` 命令

2. 进入 `git bash` ， `pwd` 可以查看当前目录所在的路径，默认为 `/c/Users/yourname` ，即C盘Users下你的个人用户目录

3. 在 `bash` 的当前目录下克隆本仓库代码到本地仓库，此时的仓库路径为 `~/git-lazypush/` 

4. 添加命令别名，名字可以自己定义 alias pp='~/git-lazypush/lazypush.sh'

5. 默认的远程测试分支名称为 `test`，如果不一样需要修改 `~/git-lazypush/lazypush.sh` 文件的第三行的分支名称

6. 进入到需要提交的 `git` 分支目录

7. 执行命令 `pp head` 按提示确认是否提交代码到远程分支即可

## 联系我（Contact Me）

``` 
有使用问题可以提交issues 或者直接邮箱联系 jh1139209675@gmail.com
```