type Script.lua > Ironbrew/netcoreapp2.0/input.txt
cd Ironbrew/netcoreapp2.0/
dotnet "IronBrew2 CLI.dll" "input.txt"
cd ../..
luac Ironbrew/netcoreapp2.0/out.lua
lua Main.lua
pause