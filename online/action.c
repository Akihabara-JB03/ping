// ボールを加速させる新機能
void SpeedUpBall(int *SX) {
    // もし現在のスピードがプラス（右に進んでいる）なら、さらにプラスする
    if (*SX > 0) {
        *SX += 1; // スピードを1上げる
    } 
    // もしスピードがマイナス（左に進んでいる）なら、さらにマイナスする
    else {
        *SX -= 1; // 左へのスピードを1上げる
    }
}
void LevelUpBall(int *SX, int *BR, int R) {
    SpeedUpBall(SX);
    *BR = R;

}
