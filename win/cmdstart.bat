@echo off

doskey rm=rm -i $*
doskey la=ls -a
doskey pym=python -i C:\dev\python\MinorDev\MathImport.py

rem Git shortcuts
doskey gs=git status $*
doskey gca=git commit -am $*
doskey gcm=git commit -m $*
doskey gd=git diff $*
doskey gp=git push $*
doskey ga=git add $*
doskey cat=fcat $*
