# Arch マシンの状態メモ

arch/setup/export-state.sh が生成。新マシンの初期設定で同じ選択をするための覚書。

## 基本
```
hostname : ArchLinux
kernel   : 7.2.2-arch1-1
timezone : Asia/Tokyo
locale   : LANG=en_US.UTF-8 
shell    : /bin/bash
AUR      : paru
```

## 有効なロケール (/etc/locale.gen)
```
en_US.UTF-8 UTF-8  
ja_JP.UTF-8 UTF-8  
```

## グラフィック
```
01:00.0 VGA compatible controller: NVIDIA Corporation GB203 [GeForce RTX 5080] (rev a1)
	Subsystem: ZOTAC International (MCO) Ltd. Device 1762
	Kernel driver in use: nvidia
01:00.1 Audio device: NVIDIA Corporation GB203 High Definition Audio Controller (rev a1)
--
16:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Granite Ridge [Radeon Graphics] (rev c5)
	Subsystem: Micro-Star International Co., Ltd. [MSI] Device 7e16
	Kernel driver in use: amdgpu
16:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Radeon High Definition Audio Controller
```

## ディスプレイマネージャ / セッション
```
display-manager -> /usr/lib/systemd/system/greetd.service
```

## 壁紙
awww は自分のキャッシュから前回の壁紙を復元するため、画像の実体は dotfiles に無い。
新マシンへ手で持っていくこと。
```
(~/Pictures/Wallpapers が無い)
```

## 手で確認すること
- SSH 秘密鍵 (~/.ssh)、gh auth login、1Password などのサインイン
- Chrome / Thunderbird のプロファイル (アカウント設定は dotfiles に含まれない)
- mozc の学習データは意図的に追跡していない (arch/.config/mozc/*.db は config1.db のみ)
