# Some trash i made at 2am to install this that works 100%
rm -rf ~/.config/alacritty
cp -r ./alacritty ~/.config
rm -rf ~/.config/fastfetch
cp -r ./fastfetch ~/.config
rm -rf ~/.config/hypr
cp -r ./hypr ~/.config
rm -rf ~/.config/kate
cp -r ./kate ~/.config
rm -rf ~/.config/macos
cp -r ./macos ~/.config
rm -rf ~/.config/waybar
cp -r ./waybar ~/.config
rm -rf ~/.config/Vencord
cp -r ./Vencord ~/.config
rm ~/.zshrc
cp ./.zshrc ~/
cp ./.aliases ~/
killall -SIGUSR2 waybar
nohup waybar & 
nohup hyprpaper & 
