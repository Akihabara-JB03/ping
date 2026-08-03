make:
	gcc pingpong_main.c action.c -IC:/raylib/raylib/src -LC:/raylib/raylib/src -lraylib -lopengl32 -lgdi32 -lwinmm -o pingpong
	gcc pingpong_main.c action.c -lraylib -llua -lopengl32 -lgdi32 -lwinmm -o pingpong.exe
