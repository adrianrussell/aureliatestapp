:: 1. KuduSync

IF /I "%IN_PLACE_DEPLOYMENT%" NEQ "1" (

  call :ExecuteCmd "%KUDU_SYNC_CMD%" -v 50 -f "%DEPLOYMENT_SOURCE%\src" -t "%DEPLOYMENT_TARGET%" -n "%NEXT_MANIFEST_PATH%" -p "%PREVIOUS_MANIFEST_PATH%" -i ".git;.hg;.deployment;deploy.cmd"

  IF !ERRORLEVEL! NEQ 0 goto error

)

:: 2. Select node version

call :SelectNodeVersion
echo "Starting Aurelia Command line install"
:: 3. Install the aurelia command line

call :ExecuteCmd !NPM_CMD! install aurelia-cli -g
echo "Aurelia Command line install Complete"

:: 4. Install npm packages

IF EXIST "%DEPLOYMENT_TARGET%\package.json" (

  pushd "%DEPLOYMENT_TARGET%"

  call :ExecuteCmd !NPM_CMD! install

  IF !ERRORLEVEL! NEQ 0 goto error

  popd

)
