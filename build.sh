#!/bin/bash
export PROJECT_TITLE="Hxcpp Test"
export PROJECT_TITLEID=VSDK00006

npx haxe build.hxml
vita-elf-create bin/Main.elf bin/Main.velf
vita-make-fself bin/Main.velf bin/eboot.bin
vita-mksfoex -s TITLE_ID="$PROJECT_TITLEID" "$PROJECT_TITLE" bin/param.sfo
vita-pack-vpk -s bin/param.sfo -b bin/eboot.bin --add sce_sys/icon0.png=sce_sys/icon0.png --add sce_sys/livearea/contents/bg.png=sce_sys/livearea/contents/bg.png --add sce_sys/livearea/contents/startup.png=sce_sys/livearea/contents/startup.png --add sce_sys/livearea/contents/template.xml=sce_sys/livearea/contents/template.xml bin/Main.vpk