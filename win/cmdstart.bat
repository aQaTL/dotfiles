@echo off
cls

doskey rm=rm -i $*
doskey la=ls -a $*
doskey pym=python -i D:\dev\python\MinorDev\MathImport.py
doskey py=python3

rem Git shortcuts
doskey gs=git status $*
doskey gca=git commit -am $*
doskey gcm=git commit -m $*
doskey gd=git diff $*
doskey gp=git push $*
doskey ga=git add $*
doskey gl=git log --oneline $*

doskey vscode=code $*

set PROMPT=$E[96maqatl$E[0m$B$E[33m$P$E[0m$$ 

