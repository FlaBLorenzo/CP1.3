#!/bin/bash

git branch -a | egrep "remotes/origin/develop"
if [ $? -ge 1 ]
then
        echo "NO EXISTE LA RAMA DEVELOP"
        return 1
fi

git branch -a | egrep "remotes/origin/master"
if [ $? -ge 1 ]
then
        echo "NO EXISTE LA RAMA MASTER"
        return 1
fi

git checkout master
git status
git merge develop
