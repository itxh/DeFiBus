@echo off
rem Copyright (C) @2017 Webank Group Holding Limited
rem
rem Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
rem in compliance with the License. You may obtain a copy of the License at
rem
rem http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software distributed under the License
rem is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
rem or implied. See the License for the specific language governing permissions and limitations under
rem the License.
rem

if not exist "%JAVA_HOME%\bin\java.exe" echo Please set the JAVA_HOME variable in your environment, We need java(x64)! & EXIT /B 1
set "JAVA=%JAVA_HOME%\bin\java.exe"

setlocal

set BASE_DIR=%~dp0
set BASE_DIR=%BASE_DIR:~0,-1%
for %%d in (%BASE_DIR%) do set BASE_DIR=%%~dpd
set CLASSPATH=.;%BASE_DIR%conf;%CLASSPATH%
set "JAVA_OPT=%JAVA_OPT% -server -Xms2g -Xmx2g -Xmn1g -XX:PermSize=128m -XX:MaxPermSize=320m"
set "JAVA_OPT=%JAVA_OPT% -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection -XX:CMSInitiatingOccupancyFraction=70 -XX:+CMSParallelRemarkEnabled -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+CMSClassUnloadingEnabled -XX:SurvivorRatio=8 -XX:+DisableExplicitGC -XX:-UseParNewGC"
set "JAVA_OPT=%JAVA_OPT% -verbose:gc -Xloggc:"%USERPROFILE%\rmq_srv_gc.log" -XX:+PrintGCDetails"
set "JAVA_OPT=%JAVA_OPT% -XX:-OmitStackTraceInFastThrow"
set "JAVA_OPT=%JAVA_OPT% -XX:-UseLargePages"
set "JAVA_OPT=%JAVA_OPT% -Djava.ext.dirs=%BASE_DIR%lib;%BASE_DIR%apps"
set "JAVA_OPT=%JAVA_OPT% -cp "%CLASSPATH%""
"%JAVA%" %JAVA_OPT% cn.webank.defibus.namesrv.DeFiBusNamesrvStartup -c ../conf/broker.properties %*

IF %ERRORLEVEL% EQU 0 (
    ECHO "DeFiBusNamesrv starts OK"
)