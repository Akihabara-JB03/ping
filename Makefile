make:
	gcc pingpong_main.c action.c -IC:/raylib/raylib/src -LC:/raylib/raylib/src -lraylib -lopengl32 -lgdi32 -lwinmm -o pingpong
	gcc online/pingpong_main.c online/action.c -IC:/raylib/raylib/src -LC:/raylib/raylib/src -lraylib -llua -lopengl32 -lgdi32 -lwinmm -o pingpong.exe
