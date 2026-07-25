#include "raylib.h"
#include "action.h"
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

        if ((BX - BR <= PX + PaddW && BX - BR >= PX) && (BY >= PY && BY <= PY + PaddH)) {
            SX = -SX;  // 横のスピードだけを反転
            point++;   // ポイントを1増やす（変数名はご自身のに合わせてください）
            XP++;
        }
        // 2P（右パドル）の当たり判定：ボールの右端（BX + BR）がパドル（PX2）に当たったか調べる
        if ((BX + BR >= PX2 && BX + BR <= PX2 + PaddW) && (BY >= PY2 && BY <= PY2 + PaddH)) {
            SX = -SX;  // 横のスピードだけを反転
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
        if (IsKeyDown(KEY_UP) && PY2 > 0) {
            PY2 -= 20;
        } 

        // 下キーが押されていて、かつパドルの下が画面（600）より上にある時だけ動く
        if (IsKeyDown(KEY_DOWN) && (PY2 + PaddH) < 600) {
            PY2 += 20;
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
            return 0;
        }
        DrawRectangle(PX,PY,PaddW,PaddH,WHITE);
        DrawRectangle(PX2,PY2,PaddW,PaddH,WHITE);
        DrawCircle(BX,BY,BR,WHITE);
        DrawText(TextFormat("SCORE:%d/%d",point,LevelUpXP),350,20,30,WHITE);
        EndDrawing();
    }
    
    UnloadMusicStream(bgm);
    CloseAudioDevice();
    return 0;
}