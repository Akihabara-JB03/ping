#include "raylib.h"
#include "action.h"
#include <stdio.h>

// 💡 Luaの機能をC言語に取り込むためのヘッダー
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

// 💡 Luaの宇宙（仮想マシン）をしまっておくグローバル変数
lua_State *L = NULL;

// 💡 Luaの初期化と部屋（くじ引き）に入る関数
void InitLuaNetwork(const char* room_id) {
    L = luaL_newstate();
    luaL_openlibs(L); // Luaの標準ライブラリを有効化

    // network.lua ファイルを読み込んで実行
    if (luaL_dofile(L, "network.lua") != LUA_OK) {
        printf("Lua読み込みエラー: %s\n", lua_tostring(L, -1));
        lua_close(L);
        L = NULL;
        return;
    }

    // Luaの中の部屋番号を設定する関数を呼ぶ
    lua_getglobal(L, "init_network_room");
    if (lua_isfunction(L, -1)) {
        lua_pushstring(L, room_id);
        lua_pcall(L, 1, 0, 0);
    } else {
        lua_pop(L, 1);
    }
}
int main(void) {
    int PX = 50;
    int PY = 250;
    int PaddW = 20;
    int PaddH = 100;
    int PX2 = 750;
    int PY2 = 250;
    int BX = 400;
    int BY = 300;
    int SX = 5;
    int SY = 5;
    int BR = 60;
    int point = 0;
    int LevelUPBR = 60;
    int XP = 0;
    int LevelUpXP = 5;
    InitWindow(800,600,"Ping Pong");

    SetTargetFPS(60);
    InitAudioDevice();

    Music bgm = LoadMusicStream("bgm.mp3");
    Sound gameover = LoadSound("gameover.mp3");
    PlayMusicStream(bgm);
    while (!WindowShouldClose()) {
        UpdateMusicStream(bgm);
        BX += SX;
        BY += SY;
        BeginDrawing();
        ClearBackground(BLACK);
        if (BY <= (0 + BR) || BY >= (600-BR)) {
            SY = -SY;
        }

        // 1P（左パドル）：パドルの上下にボールの半径（BR）の分だけ判定を広げて、すり抜けをブロック！
        if ((BX - BR <= PX + PaddW && BX - BR >= PX) && (BY >= PY - BR && BY <= PY + PaddH + BR)) {
            SX = -SX;  // 横のスピードだけを反転（ガタガタ暴れて荒稼ぎできる仕様はそのまま）
            point++;   // ポイントを1増やす
            XP++;
        }
        // 2P（右パドル）：パドルの上下にボールの半径（BR）の分だけ判定を広げて、すり抜けをブロック！
        if ((BX + BR >= PX2 && BX + BR <= PX2 + PaddW) && (BY >= PY2 - BR && BY <= PY2 + PaddH + BR)) {
            SX = -SX;  // 横のスピードだけを反転（ガタガタ暴れて荒稼ぎできる仕様はそのまま）
            point++;   // ポイントを1増やす
            XP++;
        }


        if (XP >= LevelUpXP) {
            LevelUPBR -= 3;
            if (LevelUPBR <= 7) {
                LevelUPBR = 7;
            }
            LevelUpBall(&SX,&BR,LevelUPBR);
            XP = XP - LevelUpXP;
            LevelUpXP = (point * 2) + ((7 * point) / 5);
        }
        // 上キーが押されていて、かつパドルの上が画面（0）より下にある時だけ動く
        if (IsKeyDown(KEY_W) && PY > 0) {
            PY -= 20;
        } 

        // 下キーが押されていて、かつパドルの下が画面（600）より上にある時だけ動く
        if (IsKeyDown(KEY_S) && (PY + PaddH) < 600) {
            PY += 20;
        }
        if (BX <= 0 || BX >= 800) {
            StopMusicStream(bgm);
            PlaySound(gameover);
            ClearBackground(BLACK);
            DrawText(TextFormat("Game Over\n Score:%d",point),250,250,60,WHITE);
            EndDrawing();
            WaitTime(3.0);
            UnloadMusicStream(bgm);
            UnloadSound(gameover);
            CloseAudioDevice();
            if (L != NULL) lua_close(L);
            return 0;
        }
        DrawRectangle(PX,PY,PaddW,PaddH,WHITE);
        DrawRectangle(PX2,PY2,PaddW,PaddH,WHITE);
        DrawCircle(BX,BY,BR,WHITE);
        DrawText(TextFormat("SCORE:%d/%d",point,LevelUpXP),350,20,30,WHITE);
        EndDrawing();
    }
    if (L != NULL) lua_close(L);
    UnloadMusicStream(bgm);
    CloseAudioDevice();
    return 0;
}
